import 'package:xml/xml.dart';
import '../models/hymn.dart';

class HymnParser {
  /// Converte um XML string para uma lista de objetos [Hymn].
  /// Suporta Harpa Cristã e Novo Cântico com base na tag 'tipo' ou 'category'.
  static List<Hymn> parseXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final hymns = <Hymn>[];

    final root = document.getElement('hinario');
    if (root == null) throw Exception("XML inválido: Tag <hinario> não encontrada.");

    final category = root.getAttribute('tipo') ?? 'HARPA';

    for (var node in root.findElements('hino')) {
      final hino = Hymn()
        ..category = category
        ..number = int.tryParse(node.getElement('numero')?.innerText ?? '0') ?? 0
        ..title = node.getElement('titulo')?.innerText ?? 'Sem Título'
        ..lyrics = node.getElement('letra')?.innerText ?? ''
        ..audioUrl = node.getElement('audioUrl')?.innerText;
      
      hymns.add(hino);
    }

    return hymns;
  }
}
