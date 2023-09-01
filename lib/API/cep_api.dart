import 'package:desafiodiocep/models/backforapp.dart';
import 'package:desafiodiocep/models/cep_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViaCepService with ChangeNotifier {
  final Dio _dio = Dio();
  Endereco? endereco;
  List<MyModel> resultList = [];

  ViaCepService() {
    _dio.options.headers["X-Parse-Application-Id"] =
        "10bnDguHANfY4JSoMWVn9n6A3TY4YlxWuButyaYb";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "fpbO0kIE0Izn95RwVRSiy7xEMXttXzB6xBSti5hv";
    _dio.options.headers["Content-Type"] = "application/json";
  }

  TextEditingController cepcontroller = TextEditingController();

  Future<List<MyModel>> obterCepsCadastrados() async {
    try {
      final response =
          await _dio.get("https://parseapi.back4app.com/classes/tarefas");

      for (var result in response.data['results']) {
        resultList.add(MyModel.fromJson(result));
        notifyListeners();
      }
    } catch (e) {
      print("Erro ao acessar a api BACKFORAPP");
    }

    return resultList;
  }

  Future<void> fetchCep(String cep) async {
    try {
      final response = await _dio.get('https://viacep.com.br/ws/$cep/json/');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        endereco = Endereco.fromJson(data);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> criarCep(MyModel novoCep) async {
    final response = await _dio.post(
      "https://parseapi.back4app.com/classes/tarefas",
      data: novoCep.toJson(),
    );

    if (response.statusCode == 201) {
      resultList.add(novoCep);
      notifyListeners();
    }
  }

  Future<void> excluirCep(String objectId) async {
    try {
      final response = await _dio.delete(
        "https://parseapi.back4app.com/classes/tarefas/$objectId",
      );
      notifyListeners();
    } catch (e) {
      print("Erro durante a exclusão do CEP: $e");
    }
  }

  Future<void> editarCep(MyModel cepEditado) async {
    final response = await _dio.put(
      "https://parseapi.back4app.com/classes/tarefas/${cepEditado.objectId}",
      data: cepEditado.toJson(),
    );

    if (response.statusCode == 200) {
      int index =
          resultList.indexWhere((cep) => cep.objectId == cepEditado.objectId);
      if (index != -1) {
        resultList[index] = cepEditado;
        notifyListeners();
      }
    }
  }
}
