import 'package:app_comidas/domain/entities/comidas.dart';
import 'package:app_comidas/modelos/comidas_respuestas.dart';
import 'package:dio/dio.dart';

class GetComidasRespuestas {
  final _dio = Dio();

  Future<List<Comidas>> getRespuestas() async {
    final respuesta = await _dio.get(
      'http://10.0.2.2:80/ws_comida/route.php/comidas',
    );
    final data = respuesta.data;
    if (data is List) {
      return data
          .map<Comidas>((item) => ComidasModel.fromJson(item).toMessageEntity())
          .toList();
    }

    if (data is Map<String, dynamic>) {
      final comidasModel = ComidasModel.fromJson(data);
      return [comidasModel.toMessageEntity()];
    }

    throw Exception('Formato de respuesta inesperado: ${data.runtimeType}');
  }
}
