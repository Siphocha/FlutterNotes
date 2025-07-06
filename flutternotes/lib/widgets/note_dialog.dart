// note_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../notes/note_data.dart';
import '../notes/notes_bloc.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;

  const NoteDialog({super.key, this.note});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _textController.text = widget.note!.text;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add ur Note' : 'Edit ur Note'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          decoration: const InputDecoration(labelText: 'Notes text'),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter your text manneee';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Stoop'),
        ),
        TextButton(onPressed: _submitForm, child: const Text('Save')),
      ],
    );
  }

  void _submitForm() {
    //Submitting form function
    if (_formKey.currentState!.validate()) {
      final text = _textController.text;
      if (widget.note == null) {
        context.read<NotesBloc>().add(AddNote(text));
      } else {
        context.read<NotesBloc>().add(UpdateNote(widget.note!.id!, text));
      }
      Navigator.pop(context);
    }
  }
}
