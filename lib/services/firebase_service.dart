import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Envoyer un message dans le chat d'une tâche
  static Future<void> sendMessage({
    required int taskId,
    required String username,
    required String message,
  }) async {
    await _db
        .collection('task_chats')
        .doc(taskId.toString())
        .collection('messages')
        .add({
      'username': username,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Écouter les messages en temps réel
  static Stream<QuerySnapshot> getMessages(int taskId) {
    return _db
        .collection('task_chats')
        .doc(taskId.toString())
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}