//model

import 'package:flutter/material.dart';

class Note extends ChangeNotifier {
//Variables
  String _title = "";
  String _description = "";

//Constructor
  Note(this._title, this._description);
//Getters
  String get title => _title;
  String get description => _description;

  Map<String, dynamic> toMap() {
    return {
      'title': _title,
      'description': _description,
    };
  }
}
