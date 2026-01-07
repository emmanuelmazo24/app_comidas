import 'package:app_comidas/domain/entities/comidas.dart';
import 'package:app_comidas/modelos/comidas_respuestas.dart';
import 'package:dio/dio.dart';

class PostComidaService {
  final _dio = Dio();

  Future<bool> createComida(Comidas comida) async {
    final Map<String, dynamic> data = comida.idComida.trim().isEmpty
        ? {
            'nombre_comida': comida.nombreComida,
            'autor': comida.autor,
            'costo_comida': comida.costoComida,
          }
        : ComidasModel(
            idComida: comida.idComida,
            nombreComida: comida.nombreComida,
            autor: comida.autor,
            costoComida: comida.costoComida,
          ).toJson();

    final response = await _dio.post(
      'http://10.0.2.2:80/ws_comida/route.php/comidas',
      data: data,
      options: Options(headers: {'CContent-Type': 'application/json'}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
