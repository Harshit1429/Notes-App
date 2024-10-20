import 'dart:io';
import 'package:notesapp/Model/NotesModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

import '../../Model/NotesModel.dart';
class DbHelper {

  Database? _dataBase;

  Future<Database?> get database async {

    if(_dataBase != null){
      return _dataBase;
    }

    // find and create file
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'mydatabase.db');

    // open .db file and create table
    _dataBase = await openDatabase(path, version: 1,onCreate: (db, version) {

      db.execute(
        '''
        CREATE TABLE DatabaseTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
        )
        '''
      );

    },);
   return _dataBase;
  }

  insertData(NotesModel notesModel) async {
    Database? db = await database ;

    db?.insert('DatabaseTable', notesModel.toMap());

  }

  Future<List<NotesModel>> readData() async {
    Database? db = await database;
    final list = await db!.query('DatabaseTable');
    return list.map((map) => NotesModel.fromMap(map)).toList() ;
  }

  deleteData(int id)async{
    Database? db = await database ;

    db!.delete('DatabaseTable',
    where: 'id = ?',
      whereArgs: [id]
    );
  }

  updateData(NotesModel notesModel , int id) async {
    Database? db = await database ;
    db?.update('DatabaseTable', notesModel.toMap(),
    where: 'id = ?',
      whereArgs: [id]
    );
  }

}