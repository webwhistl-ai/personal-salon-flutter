import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import '../../../providers/assistant_provider.dart';

class AssistantWidget extends ConsumerWidget {
  const AssistantWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assistantProvider);

    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        color: AppTheme.ivory,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.roseGold,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Neha AI Concierge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.chatHistory.length,
              itemBuilder: (context, index) {
                final message = state.chatHistory[index];
                final isUser = message.startsWith('You: ');
                final displayMsg = isUser ? message.replaceFirst('You: ', '') : message.replaceFirst('AI: ', '');

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? AppTheme.deepPlum : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: isUser ? null : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      displayMsg,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (state.isProcessing)
             Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.roseGold)),
                  SizedBox(width: 12),
                  Text('Processing...', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.options.map((option) {
                  return ActionChip(
                    label: Text(option),
                    backgroundColor: AppTheme.champagne.withAlpha(100),
                    side: const BorderSide(color: AppTheme.roseGold),
                    onPressed: () {
                      if (option == 'Yes, show me') {
                        Navigator.of(context).pop();
                        context.go('/services');
                        ref.read(assistantProvider.notifier).handleOptionSelected('Start over');
                      } else {
                        ref.read(assistantProvider.notifier).handleOptionSelected(option);
                      }
                    },
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
