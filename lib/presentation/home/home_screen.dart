import 'package:app_comidas/domain/entities/comidas.dart';
import 'package:app_comidas/helpers/get_comidas.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Comidas>> _comidasFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comidasFuture = GetComidasRespuestas().getRespuestas();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Listado de Comidas')),
      body: FutureBuilder<List<Comidas>>(
        future: _comidasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final comidas = snapshot.data;

          if (comidas == null || comidas.isEmpty) {
            return const Center(child: Text('No hay datos'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: comidas.length,
            itemBuilder: (context, index) {
              final comida = comidas[index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.list_alt, color: colors.primary),
                  title: Text(comida.nombreComida),
                  subtitle: Text(
                    'Autor:${comida.autor} - Costo Comida:${comida.costoComida} Id: ${comida.idComida}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: colors.secondary),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar'),
                          content: Text('¿Eliminar "${comida.nombreComida}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      final dio = Dio();
                      final url =
                          'http://10.0.2.2:80/ws_comida/route.php/comidas/${comida.idComida}';

                      try {
                        final response = await dio.delete(url);
                        if (response.statusCode == 200 ||
                            response.statusCode == 204) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Registro Eliminado')),
                          );
                          setState(() {
                            _comidasFuture = GetComidasRespuestas()
                                .getRespuestas();
                          });
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al eliminar (status ${response.statusCode})',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar Comida',
        onPressed: () async {
          final result = await context.push<bool>('/alta_comidas');

          if (result == true) {
            setState(() {
              _comidasFuture = GetComidasRespuestas().getRespuestas();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
