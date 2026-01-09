import '../firebase/DB/Repo/CategoryRepository.dart';

import 'package:flutter/material.dart';

import '../firebase/DB/Models/Categories.dart';

class CategoriesProvider with ChangeNotifier {
  // bool isOnline = true;
  CategoryRepository categoryRepository = CategoryRepository();
  List<Categories> categories = [];

  allCategoriesProvider() async {
    List<Categories> tempCategories =
        await categoryRepository.getAllCategories();

    // exercises.clear();
    categories = tempCategories;
    // setState(() {});
    // exercisesRepository.getResentExercises();
    notifyListeners();
  }
}
