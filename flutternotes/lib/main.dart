import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../notes/note_repo_implementation.dart'; // Your implementation
import '../notes/get_notes.dart'; // Use case Repository interface
import '../notes/notes_bloc.dart';
import '../authLogic/auth_bloc.dart';
import '../authLogic/auth_state.dart';
import '../pages/auth_page.dart';
import '../pages/home_page.dart';
import '../pages/splash_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with debug logging
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Test Firebase services
    await _testFirebaseConnection();

    //The print statement is just for me to firebase connection
    print('Firebase initialised: ${Firebase.apps.isNotEmpty}');

    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Error handling with your original print plus additional debugging
    print('Firebase initialization failed: $e');
    print('Stack trace: $stackTrace');

    // Fallback UI
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 20),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Failed to connect to Firebase:\n${e.toString()}',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => main(), // Restart app
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _testFirebaseConnection() async {
  try {
    // Quick test of Firestore
    await FirebaseFirestore.instance
        .collection('connection_test')
        .doc('test')
        .set({'timestamp': DateTime.now()});

    // Quick test of Auth
    await FirebaseAuth.instance.signInAnonymously();
    await FirebaseAuth.instance.signOut();

    print('Firebase services test successful');
  } catch (e) {
    print('Firebase service test failed: $e');
    throw Exception('Firebase services not working properly');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Bloc - your original comment preserved
        BlocProvider(
          create: (context) => AuthBloc(auth: FirebaseAuth.instance),
        ),

        // Notes Bloc - your original comment preserved
        BlocProvider(
          create:
              (context) => NotesBloc(
                getNotes: GetNotes(
                  NoteRepositoryImpl(
                    firestore: FirebaseFirestore.instance,
                    auth: FirebaseAuth.instance,
                  ),
                ),
                repository: NoteRepositoryImpl(
                  firestore: FirebaseFirestore.instance,
                  auth: FirebaseAuth.instance,
                ),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.initial) {
              return const SplashPage();
            } else if (state.status == AuthStatus.authenticated) {
              return const HomePage();
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}
