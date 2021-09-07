import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/helpers/drawer_navigation.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_screen.dart';
import 'package:todo/service/category_service.dart';
import 'package:todo/service/todo_service.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

 // var _todoDescriptionController = TextEditingController();
  //variables to edit a category
  var _editTodoTitleController = TextEditingController(); //variables para almacenar el texto que se ingrese
  var _editTodoDescriptionController = TextEditingController();
  var _editTodoDateController = TextEditingController();
  var _editTodoCategoryController = TextEditingController();

//variables to choose a category
  var _selectedValue;
  var _categories = <DropdownMenuItem>[];

  var _categoryService = CategoryService();
  var _category;
  //creo las variables y los métodos para mostrar mis TodoList
  TodoService _todoService = TodoService();
  List<Todo> _todoList = <Todo>[];

  //declaro variables que contienen los métods de las clases category
  var _todo = Todo();
  var todo;


  //variable to make a succesfuly message to edit a category
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  initState(){
    super.initState();
    _loadCategories();
    getAllTodos();
  }

  //method to use a category in a dropDown button
  _loadCategories() async{
    var _categoryService = CategoryService();

    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = <Todo>[];

    var todos = await _todoService.readTodos();

    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];

        _todoList.add(model);
      });
    });
  }

  //method to show a success message
  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
  }


  //initilize the DateTime
  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async{
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2500));

    if(_pickedDate != null)
    {
      setState(() {
        _dateTime = _pickedDate;
        _editTodoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('TodoList Sqflite'),
      ),
      drawer: DrawerNavigaton(),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => TodoScreen())),
      child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),

      body: ListView.builder(
        itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:  EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
              child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0)
              ),

                child: ListTile(
                  //CREO EL BOTÓN PARA EDITAR UNA TAREA
                  leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      _editCategory(context, _todoList[index].id);
                    }, 
                    //=>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>TodoScreen(),)),
                    
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_todoList[index].title,
                        textAlign: TextAlign.center,
                      ),
                  IconButton( //button for delete data
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteFormDialog(context, _todoList[index].id);
                        },
                   ),
                    ],

                  ),

                  subtitle: Text(_todoList[index].category),
                  //trailing: Text(_todoList[index].todoDate),
                )
              ),
            );
          }),

    );
  }

  //method to Delete a task
  _deleteFormDialog(BuildContext context, categoryId) async{
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
            onPressed: () async {
              var result = await _todoService.deleteTodosByCategory(categoryId);
              if(result >0){
                print(result);
                Navigator.pop(context); //return to the page 'Screen categories'
                getAllTodos(); //obtain inmediately an updated of all categories in the page
                _showSuccessSnackBar(Text('Deleted success!!')); //show the success message when we do an update
              }

            },
            child: Text('Delete'),
          ),
          FlatButton(
            onPressed: ()=>Navigator.pop(context),
            color: Colors.red,
            child: Text('Cancel'),
          ),
        ],
        title: Text("Are you sure you want to delete this?",
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[

            ],
          ),
        ),
      );
    });
  }

  //method to Edit a task
  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
            onPressed: () async{
              _todo.id = todo[0]['id'];
              _todo.title = _editTodoTitleController.text; //guardo el contenido del texfield Category name
              _todo.description = _editTodoDescriptionController.text; //guardo el contenido del texflied CategoryDescription
              _todo.category =   _selectedValue.toString();//_editTodoCategoryController.text;
              _todo.todoDate = _editTodoDateController.text;

              var result = await _todoService.updateTodosByCategory(_todo);
             // var result2 = await _categoryService.updateCategory(_category);
              //var result2 = await _categoryService.updateCategory(_category);
              // var resul2 = await _todoService
              if(result > 0 ){
                print(result);
                setState(() {
                  Navigator.pop(context); //return to the page 'Screen categories'
                  getAllTodos(); //obtain inmediately an updated of all categories in the page
                 // _showSuccessSnackBar(Text('updated success!!')); //show the success message when we do an update
                });
              }
            },

            child: Text('Update'),
          ),
          FlatButton(
            onPressed: ()=>Navigator.pop(context),
            color: Colors.red,
            child: Text('Cancel'),
          ),
        ],
        title: Text("Edit Task "),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editTodoTitleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Write todo Title',
                ),
              ),
              TextField(
                controller: _editTodoDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write todo Description',
                ),
              ),
              TextField(
                controller: _editTodoDateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a Date',
                  prefixIcon: InkWell(
                    onTap: (){
                      _selectedTodoDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
              ),
              DropdownButtonFormField(
                value: _selectedValue,
                items: _categories,
                hint: Text('Category'),
                onChanged:(dynamic value) async{
                  setState(() {
                    _selectedValue = value;
                  });
                },
              ),

            ],
          ),
        ),
      );
    });

  }

  _editCategory(BuildContext context, categoryId) async {
    //category = await _categoryService.readCategoryById(categoryId);

    todo = await _todoService.readTodosById(categoryId);
    setState(() {
      _editTodoTitleController.text = todo[0]['title'];
      _editTodoDescriptionController.text = todo[0]['description'];
      _editTodoCategoryController.text = todo[0]['category'];
      _editTodoDateController.text = todo[0]['todoDate'];
    });
    _editFormDialog(context);
  }
}
