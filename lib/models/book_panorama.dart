// lib/models/book_panorama.dart - Sem grandes alterações necessárias.
class BookPanorama {
  final String livro;
  final String autor;
  final String dataAproximada;
  final String significadoNome;
  final List<BookDivision> divisoesPrincipais;
  final List<String> temasChave;
  final String propositoPrincipal;

  BookPanorama({
    required this.livro,
    required this.autor,
    required this.dataAproximada,
    required this.significadoNome,
    required this.divisoesPrincipais,
    required this.temasChave,
    required this.propositoPrincipal,
  });

  factory BookPanorama.fromJson(Map<String, dynamic> json) {
    return BookPanorama(
      livro: json['livro'] ?? '',
      autor: json['autor'] ?? '',
      dataAproximada: json['data_aproximada'] ?? '',
      significadoNome: json['significado_nome'] ?? '',
      divisoesPrincipais: (json['divisoes_principais'] as List)
          .map((i) => BookDivision.fromJson(i))
          .toList(),
      temasChave: List<String>.from(json['temas_chave'] ?? []),
      propositoPrincipal: json['proposito_principal'] ?? '',
    );
  }
}

class BookDivision {
  final String titulo;
  final List<String> topicos;

  BookDivision({
    required this.titulo,
    required this.topicos,
  });

  factory BookDivision.fromJson(Map<String, dynamic> json) {
    return BookDivision(
      titulo: json['titulo'] ?? '',
      topicos: List<String>.from(json['topicos'] ?? []),
    );
  }
}