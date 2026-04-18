// functions/index.js

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(); // Inicializa o Admin SDK

const messaging = admin.messaging();
const firestore = admin.firestore();

// Função acionada quando um NOVO 'like' é adicionado a um devocional
exports.onLikeAdded = functions.firestore
    .document('notes/{noteId}/likes/{likeId}') // Escuta a criação de documentos na subcoleção 'likes'
    .onCreate(async (snap, context) => { // 'snap' é o documento do like que foi criado
        const noteId = context.params.noteId; // ID do devocional curtido
        const likerId = context.params.likeId; // UID de quem curtiu

        // 1. Obter os dados do devocional curtido
        const noteRef = firestore.collection('notes').doc(noteId);
        const noteDoc = await noteRef.get();

        if (!noteDoc.exists) {
            console.log('Devocional não encontrado, não é possível enviar notificação.');
            return null;
        }

        const noteData = noteDoc.data();
        const devotionalAuthorId = noteData.userId; // O UID do autor do devocional
        const devotionalTitle = noteData.title || "Um devocional"; // Título do devocional

        // Não notificar o autor se ele curtiu o próprio devocional
        if (devotionalAuthorId === likerId) {
            console.log('Autor curtiu o próprio devocional, não enviar notificação.');
            return null;
        }

        // 2. Obter o nome de quem curtiu (para uma mensagem mais personalizada)
        let likerName = "Alguém";
        try {
            const likerUserDoc = await admin.auth().getUser(likerId);
            likerName = likerUserDoc.displayName || likerUserDoc.email || likerName;
        } catch (error) {
            console.error("Erro ao obter dados de quem curtiu:", error);
        }

        // 3. Obter os tokens de notificação de TODOS os utilizadores (exceto o autor e o liker)
        const tokensSnapshot = await firestore.collection('fcmTokens').get();
        const tokens = [];
        tokensSnapshot.forEach(doc => {
            const data = doc.data();
            // Envia para todos os tokens registados, exceto o autor do devocional e o próprio liker
            if (data.token && data.token !== null && doc.id !== devotionalAuthorId && doc.id !== likerId) {
                tokens.push(data.token);
            }
        });

        if (tokens.length === 0) {
            console.log('Nenhum token FCM para enviar notificações.');
            return null;
        }

        // 4. Construir a mensagem de notificação
        const payload = {
            notification: {
                title: 'Novo Gosto no Devocional!',
                body: `${likerName} curtiu o devocional: "${devotionalTitle}"`,
                sound: 'default', // Toca o som padrão de notificação
            },
            data: {
                type: 'like_notification',
                noteId: noteId,
            }
        };

        // 5. Enviar a notificação
        const response = await MessagingToDevice(tokens, payload);
        console.log('Notificação enviada com sucesso:', response);

        // Opcional: Remover tokens inválidos para evitar erros futuros
        const tokensToRemove = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                console.error('Falha no envio para token:', tokens[index], error);
                if (error.code === 'messaging/invalid-registration-token' ||
                    error.code === 'messaging/registration-token-not-registered') {
                    tokensToRemove.push(firestore.collection('fcmTokens').doc(tokensSnapshot.docs[index].id).delete());
                }
            }
        });
        if (tokensToRemove.length > 0) {
          await Promise.all(tokensToRemove);
          console.log('Tokens inválidos removidos.');
        }

        return null;
    });

// Função acionada quando um 'like' é REMOVIDO (opcional, para manter likesCount consistente)
exports.onLikeRemoved = functions.firestore
    .document('notes/{noteId}/likes/{likeId}')
    .onDelete(async (snap, context) => {
        const noteId = context.params.noteId;
        const noteRef = firestore.collection('notes').doc(noteId);

        return noteRef.update({
            likesCount: admin.firestore.FieldValue.increment(-1)
        }).catch(error => {
            console.error("Erro ao decrementar likesCount:", error);
        });
    });