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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Bloc
        BlocProvider(
          create: (context) => AuthBloc(auth: FirebaseAuth.instance),
        ),

        // Notes Bloc
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
