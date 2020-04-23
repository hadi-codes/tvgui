// To parse this JSON data, do
//
//     final notes = notesFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';

Notes notesFromJson(String str) => Notes.fromJson(json.decode(str));

String notesToJson(Notes data) => json.encode(data.toJson());

class Notes {
  List<Note> notes;

  Notes({
    this.notes,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
      };

 static Future<Notes> fetchNotes() async {
    Dio dio = new Dio();
    try {
      Response response = await dio.get("https://api.hadi.wtf/dev-notes");
      Notes notes = Notes.fromJson(jsonDecode(response.toString()));
      return notes;
    } catch (e) {
      return Notes(notes: [Note(text: "يوجد خطأ ")]);
    }
  }
}

class Note {
  String text;

  Note({
    this.text,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}
