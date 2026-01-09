import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../models/new_model.dart';

class ImageProviderData with ChangeNotifier {
  final Isar isar;
  List<String> _images = [];

  ImageProviderData(this.isar);

  List<String> get images => _images;

  Future<void> loadImages() async {
    final data = await isar.imageModels.where().findAll();
    _images = data.map((img) => img.imagePath).toList();
    notifyListeners();
  }
}
