import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../logic/providers.dart';
import '../../../data/repositories/bible_repository.dart';
import '../../../data/services/bible_import_service.dart';
import '../../../data/services/remote_bible_content_service.dart';
import '../reading_progress_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  static const List<String> versionOrder = ['NAA', 'ACF', 'ARA', 'ARC', 'KJF', 'NVI', 'NVT', 'NTLH'];
  final RemoteBibleContentService _remoteService = RemoteBibleContentService();

  static const Map<String, String> bibleVersionNames = {
    'NAA': 'Nova Almeida Atualizada',
    'ACF': 'Almeida Corrigida Fiel',
    'ARA': 'Almeida Revista e Atualizada',
    'ARC': 'Almeida Revista e Corrigida',
    'KJF': 'King James Faithful',
    'NVI': 'Nova Versão Internacional',
    'NVT': 'Nova Versão Transformadora',
    'NTLH': 'Nova Tradução na Linguagem de Hoje',
  };

  @override
  Widget build(BuildContext context) {
    final activeVersion = ref.watch(activeBibleVersionProvider);
    final bibleRepo = ref.watch(bibleRepositoryProvider);
    final syncService = ref.watch(firebaseSyncServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text('Definições', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<User?>(
        stream: syncService?.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data;
          
          return ListView(
            padding: EdgeInsets.fromLTRB(
              0,
              8,
              0,
              24 + MediaQuery.of(context).padding.bottom,
            ),
            children: [
              _buildAuthSection(user, syncService),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 32),
              ),
              _buildSectionHeader('Preferências de Leitura'),
              ListTile(
                leading: const Icon(Icons.library_books_outlined, color: Color(0xFF5D4037)),
                title: const Text('Versão da Bíblia Ativa'),
                subtitle: Text(bibleVersionNames[activeVersion] ?? activeVersion, style: const TextStyle(fontSize: 13)),
                trailing: const Icon(Icons.info_outline, size: 20, color: Color(0xFFD4AF37)),
                onTap: () => _showVersionInfoDialog(ref, bibleRepo, activeVersion),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 32),
              ),
              _buildSectionHeader('Gestão de Conteúdo'),
              ...versionOrder.map((id) => _buildManagementTile(context, bibleRepo, id, bibleVersionNames[id] ?? id)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 32),
              ),
              _buildSectionHeader('Progresso de Leitura'),
              ListTile(
                leading: const Icon(Icons.trending_up_outlined, color: Color(0xFF5D4037)),
                title: const Text('Resumo de Progresso'),
                subtitle: const Text('Ver e gerenciar progresso dos livros', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ReadingProgressScreen(
                      bibleRepo: bibleRepo,
                      activeVersion: activeVersion,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 32),
              ),
              _buildSectionHeader('Aplicação'),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Color(0xFF5D4037)),
                title: const Text('Sobre o Aplicativo'),
                onTap: () => _showAboutDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.lato(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 1.2,
          color: const Color(0xFFD4AF37),
        ),
      ),
    );
  }

  Widget _buildAuthSection(User? user, syncService) {
    if (user != null) {
      return ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.3), width: 2),
          ),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[200],
            backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null ? const Icon(Icons.person, size: 20, color: Colors.grey) : null,
          ),
        ),
        title: Text(user.displayName ?? 'Utilizador', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user.email ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        trailing: IconButton(
          icon: const Icon(Icons.logout_outlined, size: 20, color: Colors.redAccent),
          onPressed: () => syncService?.signOut(),
          tooltip: 'Sair',
        ),
      );
    }

    return ListTile(
      leading: const Icon(Icons.cloud_queue, color: Color(0xFFD4AF37)),
      title: const Text('Sincronização Cloud'),
      subtitle: const Text('Mantenha os seus dados seguros', style: TextStyle(fontSize: 13)),
      trailing: TextButton(
        onPressed: () async {
          try {
            await syncService?.signInWithGoogle();
          } catch (e) {
            _showError("Erro ao iniciar sessão");
          }
        },
        child: Text(
          'ENTRAR',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5D4037),
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<_BibleVersionTileData> _loadVersionTileData(BibleRepository bibleRepo, String id) async {
    final isInstalled = await bibleRepo.isVersionImported(id);

    if (id == 'NAA' || isInstalled) {
      return _BibleVersionTileData(isInstalled: isInstalled);
    }

    try {
      final item = await _remoteService.getBibleVersionCatalogItem(id);
      return _BibleVersionTileData(
        isInstalled: isInstalled,
        sizeBytes: item.sizeBytes,
      );
    } catch (_) {
      return _BibleVersionTileData(isInstalled: isInstalled);
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';

    const units = ['B', 'KB', 'MB', 'GB'];
    double value = bytes.toDouble();
    int unitIndex = 0;

    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }

    final decimals = unitIndex == 0 ? 0 : 1;
    return '${value.toStringAsFixed(decimals)} ${units[unitIndex]}';
  }

  Future<void> _installBibleVersion(String id, String name) async {
    final dao = ref.read(bibleDaoProvider);
    final bibleImport = BibleImportService(dao);

    if (id == 'NAA') {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text('A carregar $name...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      await bibleImport.importFromJson(id, 'assets/biblias/NAA.json');
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Versão instalada com sucesso!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {});
      return;
    }

    final progress = ValueNotifier<double>(0.0);
    final remoteService = RemoteBibleContentService();
    String? downloadedFilePath;

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'A instalar $name',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
          ),
          content: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (context, value, _) {
              final percent = (value * 100).clamp(0, 100).toStringAsFixed(0);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: value == 0 ? null : value),
                  const SizedBox(height: 12),
                  Text('Progresso: $percent%'),
                ],
              );
            },
          ),
        );
      },
    );

    try {
      downloadedFilePath = await remoteService.downloadBibleVersionJson(
        id,
        onProgress: (p) {
          progress.value = (p * 0.6).clamp(0.0, 1.0);
        },
      );

      final jsonString = await File(downloadedFilePath).readAsString();
      await bibleImport.importFromJsonString(
        id,
        jsonString,
        onProgress: (p) {
          progress.value = (0.6 + (p * 0.4)).clamp(0.0, 1.0);
        },
      );

      progress.value = 1.0;
      if (mounted) {
        Navigator.of(context).pop();
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Versão instalada com sucesso!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Falha ao baixar $name. Verifique a internet e tente novamente.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      progress.dispose();
      if (downloadedFilePath != null) {
        final downloadedFile = File(downloadedFilePath);
        if (await downloadedFile.exists()) {
          await downloadedFile.delete();
        }
      }
    }
  }

  Widget _buildManagementTile(BuildContext context, bibleRepo, String id, String name) {
    return FutureBuilder<_BibleVersionTileData>(
      future: _loadVersionTileData(bibleRepo, id),
      builder: (context, snapshot) {
        final tileData = snapshot.data ?? const _BibleVersionTileData(isInstalled: false);
        final isInstalled = tileData.isInstalled;
        final subtitle = isInstalled
          ? (id == 'NAA' ? 'Instalada (obrigatória)' : 'Instalada')
            : (id == 'NAA'
                ? 'Disponível (local)'
                : (tileData.sizeBytes != null
                    ? 'Disponível para download (${_formatBytes(tileData.sizeBytes!)})'
                    : 'Disponível para download'));

        return ListTile(
          dense: true,
          leading: Icon(
            isInstalled ? Icons.check_circle_rounded : Icons.download_for_offline_outlined,
            color: isInstalled ? Colors.green[400] : Colors.grey[400],
            size: 22,
          ),
          title: Text(name, style: const TextStyle(fontSize: 14)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: isInstalled
            ? (id == 'NAA'
                ? const Icon(Icons.lock_outline, size: 20, color: Colors.brown)
                : IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                    onPressed: () async {
                      await bibleRepo.deleteVersion(id);
                      if (ref.read(activeBibleVersionProvider) == id) {
                        // Se deletou a versão ativa, volta para NAA
                        ref.read(activeBibleVersionProvider.notifier).state = 'NAA';
                      }
                      setState(() {});
                    },
                  ))
            : TextButton(
                onPressed: () async {
                  await _installBibleVersion(id, name);
                },
                child: const Text('BAIXAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown)),
              ),
        );
      },
    );
  }

  void _showVersionInfoDialog(WidgetRef ref, bibleRepo, String current) async {
    if (bibleRepo == null) return;
    final installedIds = await bibleRepo.getImportedVersions();
    final installedVersions = versionOrder.where((id) => installedIds.contains(id)).toList();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(bibleVersionNames[current] ?? current, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Versão Ativa',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12, color: const Color(0xFFD4AF37)),
              ),
              const SizedBox(height: 8),
              Text(
                bibleVersionNames[current] ?? current,
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Text(
                'Trocar para',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12, color: const Color(0xFFD4AF37)),
              ),
              const SizedBox(height: 8),
              ...installedVersions.where((id) => id != current).map((id) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text(bibleVersionNames[id] ?? id, style: GoogleFonts.lato(fontSize: 13)),
                  trailing: const Icon(Icons.check_circle_outline, size: 20, color: Color(0xFFD4AF37)),
                  onTap: () {
                    ref.read(activeBibleVersionProvider.notifier).state = id;
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Versão alterada para ${bibleVersionNames[id] ?? id}'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Bíblia & Hinos',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.book, size: 50, color: Color(0xFF5D4037)),
      children: [
        const Text('Plataforma completa de estudo bíblico e louvor.'),
      ],
    );
  }
}

class _BibleVersionTileData {
  final bool isInstalled;
  final int? sizeBytes;

  const _BibleVersionTileData({
    required this.isInstalled,
    this.sizeBytes,
  });
}
