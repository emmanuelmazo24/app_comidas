import 'package:app_comidas/domain/entities/comidas.dart';

class ComidasModel {
  final String idComida;
  final String nombreComida;
  final String autor;
  final String costoComida;

  ComidasModel({
    required this.idComida,
    required this.nombreComida,
    required this.autor,
    required this.costoComida,
  });

  factory ComidasModel.fromJson(Map<String, dynamic> json) => ComidasModel(
    idComida: json["id_comida"],
    nombreComida: json["nombre_comida"],
    autor: json["autor"],
    costoComida: json["costo_comida"],
  );

  Comidas toMessageEntity() => Comidas(
    idComida: idComida,
    nombreComida: nombreComida,
    autor: autor,
    costoComida: costoComida,
  );

  Map<String, dynamic> toJson() => {
    "id_comida": idComida,
    "nombre_comida": nombreComida,
    "autor": autor,
    "costo_comida": costoComida,
  };
}
