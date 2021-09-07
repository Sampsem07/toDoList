import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/service/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo/service/todo_service.dart';

import 'home_screen.dart';

class TodoScreen extends StatefulWidget{
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>{
  var _todoTitleController = TextEditingController();

  var _todoDescriptionController = TextEditingController();

  var _todoDateController = TextEditingController();

   var _selectedValue;
  var _categories = <DropdownMenuItem>[];


  @override
  void initState(){
    super.initState();
    _loadCategories();
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
          _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create toDo List'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write todo Title',
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Write todo Description',
              ),
            ),
            TextField(
              controller: _todoDateController,
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
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async{
                var todoObject = Todo();

                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.isFinished = 0;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = _todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if(result >0){
                  print(result);
                  setState(() {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context)=>HomeScreen()
                        )
                    );
                  });
                  //_showSuccessSnackBar(Text('Created!!')); //show the success message when we do an update
                }
              },
            color: Colors.green,
              child: Text("Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
