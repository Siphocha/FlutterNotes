import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../notes/note_data.dart';
import '../notes/get_notes.dart';
import '../notes/note_repo.dart';

//Event for notes just being notes (NotesEvent)
abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object> get props => [];
}

//Series of Classes to determine note states when events happen.
class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final String text;
  const AddNote(this.text);
  @override
  List<Object> get props => [text];
}

class UpdateNote extends NotesEvent {
  final String id;
  final String text;
  const UpdateNote(this.id, this.text);
  @override
  List<Object> get props => [id, text];
}

class DeleteNote extends NotesEvent {
  final String id;
  const DeleteNote(this.id);
  @override
  List<Object> get props => [id];
}

//STATEESS OF NOTTEESSSS
enum NotesStatus { initial, loading, success, error }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> notes;
  final String? errorMessage;

  const NotesState({
    this.status = NotesStatus.initial,
    this.notes = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, notes, errorMessage];

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? errorMessage,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

//Blocs to STATE MANAGEMENT!
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotes getNotes;
  final NoteRepository repository;

  NotesBloc({required this.getNotes, required this.repository})
    : super(const NotesState()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  //Potential events of adding, updating, deleting notes and their state updates.
  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      final notes = await getNotes();
      emit(state.copyWith(status: NotesStatus.success, notes: notes));
    } catch (e) {
      emit(
        state.copyWith(status: NotesStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      await repository.addNote(event.text);
      final notes = await getNotes();
      emit(state.copyWith(status: NotesStatus.success, notes: notes));
    } catch (e) {
      emit(
        state.copyWith(status: NotesStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      await repository.updateNote(event.id, event.text);
      final notes = await getNotes();
      emit(state.copyWith(status: NotesStatus.success, notes: notes));
    } catch (e) {
      emit(
        state.copyWith(status: NotesStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      await repository.deleteNote(event.id);
      final notes = await getNotes();
      emit(state.copyWith(status: NotesStatus.success, notes: notes));
    } catch (e) {
      emit(
        state.copyWith(status: NotesStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
