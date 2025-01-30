//ViewModel

import 'package:flutter/material.dart';
import 'package:noteapp/Note.dart';

class NoteList extends ChangeNotifier {
  List<Note> _notelist = [];

  List<Note> get noteList => _notelist;

  // Function to add a task
  void addTask(String title, String description) {
    Note newTask = Note(title, description);
    _notelist.add(newTask);
    notifyListeners();
  }
}
