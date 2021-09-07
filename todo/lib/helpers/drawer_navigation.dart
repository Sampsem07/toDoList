import 'package:flutter/material.dart';
import 'package:todo/screens/categories_screen.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/todos_by_category.dart';
import 'package:todo/service/category_service.dart';
//CREO MI CLLASE PARA TENER UN NAVIGATION DRAWER
class DrawerNavigaton extends StatefulWidget {
  @override
  _DrawerNavigatonState createState() => _DrawerNavigatonState();

}

class _DrawerNavigatonState extends State<DrawerNavigaton>{
  //método para mostrar en el drawer las 3 categorias que necesito para mi todoList
  List<Widget> _categoryList = <Widget>[];
  CategoryService _categoryService = CategoryService();

  @override
  initState(){
    super.initState();
    getAllCategories();
  }
  getAllCategories() async{
    var categories = await _categoryService.readCategories();

    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(
              context,
              new MaterialPageRoute(
              builder: (context) => new TodosByCategory(category: category['name']))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader( //agrego un espacio ppara poner nombre, foto y correo
                currentAccountPicture: CircleAvatar( //poner la foto en forma de circulo
                  backgroundImage: NetworkImage( //en esta instrucción coloco la dirección de la imagen
                      'https://www.facebook.com/photo/?fbid=1496891737177573&set=a.104059599794134'),
                ),
                accountName: Text('L. Fernando Salazar'),
                accountEmail: Text('Salazar77.af.8@gmail.com'),
              decoration: BoxDecoration(color: Colors.green), //le doy un color de fondo
            ),
            ListTile( //agrego una opcion en el navigationDrawer
              leading: Icon(Icons.home), //con esta instrucción agrego íconos
              title: Text('Home'),
              //Le agrego funcionalidad al botón
              onTap: () => Navigator.of(context).push( //le asigno la ruta de la pantalla
                  MaterialPageRoute(                    //a la que quiero que se diriga
                      builder: (context) =>HomeScreen()
                  )
              ),
            ),
            //AGREGO OTRO LISTTILE
            ListTile( //agrego una opcion en el navigationDrawer
              leading: Icon(Icons.view_list), //con esta instrucción agrego íconos
              title: Text('Categories'),
              onTap: () => Navigator.of(context).push( //le asigno la ruta de la pantalla
                  MaterialPageRoute(                    //a la que quiero que se diriga
                  builder: (context) =>CategoriesScreen()
                  )
              ),//le agrego funcionalidad de botón al
            ),
            Divider(),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
 }


