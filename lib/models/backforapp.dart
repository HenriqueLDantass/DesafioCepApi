// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MyModel {
  String cep;
  final String objectId;
  MyModel({
    required this.objectId,
    required this.cep,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      objectId: json['objectId'] ?? "",
      cep: json['cep'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'cep': cep,
    };
  }

  factory MyModel.fromMap(Map<String, dynamic> map) {
    return MyModel(
      cep: map['cep'] as String,
      objectId: map['objectid'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
