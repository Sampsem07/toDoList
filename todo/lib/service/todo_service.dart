import 'package:todo/models/category.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/repository.dart';

class TodoService{
  Repository _repository = Repository() ;

  TodoService(){
    _repository = Repository();
  }
  //create todos
  saveTodo(Todo todo)async{
    return await _repository.insertData('todos', todo.todoMap());
  }

  //read todos
  readTodos() async {
    return await _repository.readData('todos');
  }


  //Read todos by category
  readTodosByCategory(category) async{
    return await _repository.readDataByColumName('todos', 'category', category);
  }
  //read data from table by id
  readTodosById(categoryId) async {
    return await _repository.readDataById('todos', categoryId);

  }

  //delete data from table
  deleteTodosByCategory(categoryId) async {
    return await _repository.deleteData('todos', categoryId);
  }

  updateTodosByCategory(Todo todo) async{
    return await _repository.updateData('todos', todo.todoMap());
  }
}