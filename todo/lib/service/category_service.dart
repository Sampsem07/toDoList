import 'package:flutter/material.dart';
import 'package:todo/models/category.dart';
import 'package:todo/repositories/repository.dart';

class CategoryService{
   Repository _repository = Repository();

  CategoryServices() async {
    _repository = Repository();
  }

  //create data
  saveCategory(Category category) async{
    return await _repository.insertData('categories', category.categoryMap());
  }

  //read Data from table
  readCategories() async {
    return await _repository.readData('categories');
  }

  //read data from table by id
  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);

  }

  //update data from table
  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());

  }

  //delete data from table
  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }

}