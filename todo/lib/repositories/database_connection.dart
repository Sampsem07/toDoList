import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/*
* CLASE PARA CREAR UNA BASE DE DATOS EN SQLITE
*
 */

class DatabaseConnection{ //
 setDatabase() async{
  var directory = await getApplicationDocumentsDirectory();
  var path = join(directory.path,'db_todolist_sqflite');
  var database = await openDatabase(path, version: 1, onCreate: _onCreatingDatabase); //mando traer el método _onCreateDatabase
  return database;
 }
 _onCreatingDatabase(Database database, int version) async{ //método para crear la base de datos 'categories'
  await database.execute("CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)");

  //create a table toDo
  await database.execute("CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEX, category TEXT, todoDate Text, isFinished INTEGER)");
  
 }
}