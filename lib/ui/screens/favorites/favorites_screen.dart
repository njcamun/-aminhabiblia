import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/providers.dart';
import '../hymnal/hymn_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionId = ref.watch(activeBibleVersionProvider);
    final activeHymnal = ref.watch(activeHymnalProvider);
    
    final favoriteVersesAsync = ref.watch(favoriteVersesProvider(versionId));
    final favoriteHymnsAsync = ref.watch(favoriteHymnsProvider(activeHymnal));

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Favoritos')),
      body: favoriteVersesAsync.when(
        data: (favoriteVerses) => favoriteHymnsAsync.when(
          data: (favoriteHymns) {
            if (favoriteHymns.isEmpty && favoriteVerses.isEmpty) {
              return const Center(child: Text('Ainda não tens favoritos.'));
            }

            return ListView(
              children: [
                if (favoriteVerses.isNotEmpty) ...[
                  const _Header(title: 'Versículos Favoritos'),
                  ...favoriteVerses.map((v) => ListTile(
                    title: Text(v.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text("${v.bookName} ${v.chapter}:${v.verse}"),
                    leading: const Icon(Icons.book, color: Colors.brown),
                  )),
                ],
                if (favoriteHymns.isNotEmpty) ...[
                  const _Header(title: 'Hinos Favoritos'),
                  ...favoriteHymns.map((h) => ListTile(
                    title: Text(h.title),
                    subtitle: Text("Hino ${h.number}"),
                    leading: const Icon(Icons.music_note, color: Colors.brown),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HymnDetailScreen(hymn: h)),
                    ),
                  )),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erro ao carregar hinos: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar versículos: $e')),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
