import 'package:flutter/material.dart'; // Flutter UI toolkit

const colorList = <Color>[
  // Lista de colores disponibles como 'seeds' para el tema
  Colors.blue, // opción 0
  Colors.teal, // opción 1
  Colors.green, // opción 2
  Colors.red, // opción 3
  Colors.purple, // opción 4
  Colors.deepPurple, // opción 5
  Colors.orange, // opción 6
  Colors.pink, // opción 7
  Colors.pinkAccent, // opción 8
];

class AppTheme {
  final int selectedColor; // Índice del color seleccionado dentro de colorList
  AppTheme({this.selectedColor = 0}) // Constructor con valor por defecto 0
    : assert(
        selectedColor >= 0,
        'El color debe ser > 0 ',
      ), // Valida rango mínimo
      assert(
        selectedColor <
            colorList.length, // Valida que el índice no exceda la lista
        'El color debe ser < ${colorList.length - 1}',
      );

  ThemeData getTheme() => ThemeData(
    // Método que construye y retorna ThemeData
    useMaterial3: true, // Habilita Material 3 (estilos modernos)
    colorSchemeSeed:
        colorList[selectedColor], // Usa el color seleccionado como semilla para la paleta
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ), // Tema para AppBar: título centrado
  );
}
