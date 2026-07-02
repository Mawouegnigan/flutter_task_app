import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_api_model.dart';
import 'package:flutter_task_app/services/firebase_service.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/utils/translations.dart';

class TaskChatScreen extends StatefulWidget {
  final TaskApiModel task;
  final String username;

  const TaskChatScreen({
    super.key,
    required this.task,
    required this.username,
  });

  @override
  State<TaskChatScreen> createState() => _TaskChatScreenState();
}

class _TaskChatScreenState extends State<TaskChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    await FirebaseService.sendMessage(
      taskId: widget.task.id!,
      username: widget.username,
      message: message,
    );

    // Scroll vers le bas
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chat', style: TextStyle(fontSize: 16)),
            Text(
              widget.task.title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Messages ─────────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseService.getMessages(widget.task.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'chat_empty'.tr(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textDarkSecondary),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data =
                        messages[index].data() as Map<String, dynamic>;
                    final isMe = data['username'] == widget.username;
                    final timestamp = data['timestamp'] as Timestamp?;
                    final time = timestamp != null
                        ? '${timestamp.toDate().hour.toString().padLeft(2, '0')}h${timestamp.toDate().minute.toString().padLeft(2, '0')}'
                        : '';

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primary
                              : AppColors.textDarkSecondary.withAlpha(30),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                data['username'] ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            Text(
                              data['message'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: isMe
                                    ? Colors.white
                                    : AppColors.textDarkPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe
                                    ? Colors.white.withAlpha(180)
                                    : AppColors.textDarkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ── Champ de saisie ──────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'chat_hint'.tr(context),
                      hintStyle: const TextStyle(
                          color: AppColors.textDarkSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          AppColors.textDarkSecondary.withAlpha(20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}