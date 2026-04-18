// lib/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import crucial
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserFcmToken() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      // debugPrint('Nenhum usuário logado para salvar o token FCM.'); // Removido em produção
      return;
    }

    String? fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken == null) {
      // debugPrint('Nenhum token FCM disponível para salvar.'); // Removido em produção
      return;
    }

    await _firestore.collection('fcmTokens').doc(currentUser.uid).set({
      'token': fcmToken,
      'userId': currentUser.uid, // Guarda o userId para regras de segurança
      'timestamp': FieldValue.serverTimestamp(), // Adiciona um timestamp
    }, SetOptions(merge: true));

    // debugPrint('FCM Token salvo/atualizado para ${currentUser.uid}: $fcmToken'); // Removido em produção
  }
}