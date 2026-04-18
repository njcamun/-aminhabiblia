// lib/data/colors_data.dart
import 'package:flutter/material.dart';

class NoteColorOption {
  final String name; // Nome da cor (ex: "Cinza Claro")
  final String hex;  // Valor hexadecimal da cor (ex: "0xFFE0E0E0")

  const NoteColorOption({required this.name, required this.hex}); // Adicionar 'const' ao construtor
}

class AppColors {
  static const String defaultNoteColorHex = '0xFFE0E0E0'; // Cinza claro

  static final List<NoteColorOption> noteColorOptions = const [ // Adicionar 'const' aqui
    NoteColorOption(name: 'Nenhum (Padrão)', hex: '0xFFE0E0E0'), // Cinza Claro
    NoteColorOption(name: 'Amarelo Claro', hex: '0xFFFFF3CD'),
    NoteColorOption(name: 'Azul Claro', hex: '0xFFD1ECF1'),
    NoteColorOption(name: 'Verde Claro', hex: '0xFFD4EDDA'),
    NoteColorOption(name: 'Rosa Claro', hex: '0xFFF8D7DA'),
    NoteColorOption(name: 'Laranja Claro', hex: '0xFFFFECB3'),
    NoteColorOption(name: 'Roxo Claro', hex: '0xFFE6E6FA'),
  ];

  // Helper para converter string HEX para Color
  static Color hexToColor(String hexString) {
    return Color(int.parse(hexString));
  }
}