import 'package:flutter/cupertino.dart';

import '../models/models_model.dart';
import '../services/api_service.dart';

class ModelsProvider with ChangeNotifier {
  // String currentModel = "text-davinci-003";
  String currentModel = "text-davinci-003";
  String currentAudioModel = "whisper-1";
  String get getCurrentModel {
    return currentModel;
  }

  String get getAudioModel {
    return currentAudioModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  void setCurrentAudioModel(String newModel) {
    currentAudioModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
