import 'package:app_comidas/domain/entities/comidas.dart';
import 'package:app_comidas/helpers/post_comida.dart';
import 'package:flutter/material.dart';

class AddComidas extends StatefulWidget {
  const AddComidas({super.key});

  @override
  State<AddComidas> createState() => _AddComidasState();
}

class _AddComidasState extends State<AddComidas> {
  final _formKey = GlobalKey<FormState>();
  final _nombreComidaController = TextEditingController();
  final _autorController = TextEditingController();
  final _costoComidaController = TextEditingController();
  final _service = PostComidaService();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nombreComidaController.dispose();
    _autorController.dispose();
    _costoComidaController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final comida = Comidas(
      idComida: '',
      nombreComida: _nombreComidaController.text.trim(),
      autor: _autorController.text.trim(),
      costoComida: _costoComidaController.text.trim(),
    );

    try {
      final ok = await _service.createComida(comida);
      if (ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comida creado correctamente')),
        );
        Navigator.of(context).pop(true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al crear comida')));
      }
    } catch (e) {
      if (mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exception: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alta de Comida')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nombreComidaController,
                  decoration: const InputDecoration(labelText: 'Nombre Comida'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingrese nombre de la comida'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(labelText: 'Autor'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingrese autor' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _costoComidaController,
                  decoration: const InputDecoration(labelText: 'Costo Comida'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingrese costo comida'
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Crear Comida'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
