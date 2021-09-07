import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/service/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();

}
class _CategoriesScreenState extends State<CategoriesScreen>{
  //variables to create a category
  var _categoryNameController = TextEditingController(); //variables para almacenar el texto que se ingrese
  var _categoryDescriptionController = TextEditingController();

  //declaro variables que contienen los métods de las clases category
  var _category = Category();
  var _categoryService = CategoryService();

  //variables to edit a category
  var _editCategoryNameController = TextEditingController(); //variables para almacenar el texto que se ingrese
  var _editCategoryDescriptionController = TextEditingController();

  //creo una lista donde mostraré los datos de la bd
  List<Category> _categoryList = <Category>[];
  var category;

  @override
  void initState(){ //to initialize when running the app
    super.initState();
    getAllCategories();
  }

  //variable to make a succesfuly message to edit a category
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  //method to show All existing categories
  getAllCategories() async{ //método que optiene todas las categorias de tareas
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

 //method to edit a category
  _editCategory(BuildContext context, categoryId) async
  {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'no name';
      _editCategoryDescriptionController.text = category[0]['description'] ?? 'no description';
    });
    _editFormDialog(context);
  }

  //Dialog to create a task
  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
              onPressed: () async {
                _category.name = _categoryNameController.text; //guardo el contenido del texfield Category name
                _category.description = _categoryDescriptionController.text; //guardo el contenido del texflied CategoryDescription
                var result = await _categoryService.saveCategory(_category);
                if(result >0){
                  print(result);
                  Navigator.pop(context); //return to the page 'Screen categories'
                  getAllCategories(); //obtain inmediately an updated of all categories in the page
                  //_showSuccessSnackBar(Text('Created!!')); //show the success message when we do an update
                }
              },

              child: Text('Save'),
          ),
          FlatButton(
            onPressed: ()=>Navigator.pop(context),
            color: Colors.red,
            child: Text('Cancel'),
          ),
        ],
        title: Text("Caregories Form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(

               controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write a category',
                  labelText: 'Category'

                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description'
                ),
              ),
            ],
          ),
        ),
      );
    });

  }

  //Dialog to edit a task
  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
            onPressed: () async{
              _category.id = category[0]['id'];
              _category.name = _editCategoryNameController.text; //guardo el contenido del texfield Category name
              _category.description = _editCategoryDescriptionController.text; //guardo el contenido del texflied CategoryDescription


              var result = await _categoryService.updateCategory(_category);
              if(result >0){
                print(result);
                Navigator.pop(context); //return to the page 'Screen categories'
                getAllCategories(); //obtain inmediately an updated of all categories in the page
                _showSuccessSnackBar(Text('updated success!!')); //show the success message when we do an update
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
        title: Text("Edit Categories Form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editCategoryNameController,
                decoration: InputDecoration(
                    hintText: 'Write a category',
                    labelText: 'Category'
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: InputDecoration(
                    hintText: 'Write a description',
                    labelText: 'Description'
                ),
              ),
            ],
          ),
        ),
      );
    });

  }

  //method to Delete a category
  _deleteFormDialog(BuildContext context, categoryId) async{
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.green,
            onPressed: () async {
              var result = await _categoryService.deleteCategory(categoryId);
              if(result >0){
                print(result);
                Navigator.pop(context); //return to the page 'Screen categories'
                getAllCategories(); //obtain inmediately an updated of all categories in the page
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

  //method to show a success message
  _showSuccessSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(_snackBar);
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
     appBar: AppBar(
       backgroundColor: Colors.green,
       //agrego un botón en la parte del appBar
       leading: RaisedButton(
         onPressed: () => Navigator.of(context).push(
             MaterialPageRoute(
                 builder: (context)=>HomeScreen()
             )),
         elevation: 0.0,
       child: Icon(Icons.arrow_back, color: Colors.white,),
         color: Colors.green,
       ),
       title: Text('Categories'),
     ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 16.0, right: 16.0),
              child: Card(
                elevation: 5.0 ,
                child: ListTile(
                  leading: IconButton(icon: Icon(Icons.edit),
                    onPressed: (){
                    //declaro el método para llamar al editDialog
                      _editCategory(context, _categoryList[index].id);
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_categoryList[index].name.toString()),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        onPressed: () {
                            _deleteFormDialog(context, _categoryList[index].id);
                        },
                      ),
                ],
                ),
                  subtitle: Text(_categoryList[index].description),
                ),
              ),
            );
      }
      ),
      //agrego un floatingButton
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showFormDialog(context);
        },
        child: Icon(Icons.add),

      ),
    );
  }

}