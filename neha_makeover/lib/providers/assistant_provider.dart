import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AssistantStep {
  initial,
  bookingOccasion,
  serviceSelection,
  priceCheck,
  faq
}

class AssistantState {
  final AssistantStep currentStep;
  final List<String> chatHistory; // simple log of AI messages
  final List<String> options;

  AssistantState({
    this.currentStep = AssistantStep.initial,
    this.chatHistory = const ['Hi! I am your Neha Makeover concierge. How can I help you today?'],
    this.options = const ['Book an appointment', 'Check prices', 'Ask a question'],
  });

  AssistantState copyWith({
    AssistantStep? currentStep,
    List<String>? chatHistory,
    List<String>? options,
  }) {
    return AssistantState(
      currentStep: currentStep ?? this.currentStep,
      chatHistory: chatHistory ?? this.chatHistory,
      options: options ?? this.options,
    );
  }
}

class AssistantNotifier extends Notifier<AssistantState> {
  @override
  AssistantState build() {
    return AssistantState();
  }

  void handleOptionSelected(String option) {
    List<String> newHistory = List.from(state.chatHistory)..add('You: $option');

    if (state.currentStep == AssistantStep.initial) {
      if (option == 'Book an appointment') {
        newHistory.add('AI: Great! What is the occasion?');
        state = state.copyWith(
          currentStep: AssistantStep.bookingOccasion,
          chatHistory: newHistory,
          options: ['Bridal', 'Party', 'Regular Maintenance', 'Just relaxing'],
        );
      } else if (option == 'Check prices') {
        newHistory.add('AI: I can help with that. Are you looking for hair, makeup, or skin services?');
        state = state.copyWith(
          currentStep: AssistantStep.priceCheck,
          chatHistory: newHistory,
          options: ['Hair', 'Makeup', 'Skin / Facials', 'Back to menu'],
        );
      } else {
        newHistory.add('AI: I am a demo assistant. You can check our policies in the menu.');
        state = state.copyWith(
          chatHistory: newHistory,
          options: ['Start over'],
        );
      }
    } else if (state.currentStep == AssistantStep.bookingOccasion) {
      newHistory.add('AI: Perfect. For $option, we recommend our signature packages. Would you like to browse services now?');
      state = state.copyWith(
        currentStep: AssistantStep.serviceSelection,
        chatHistory: newHistory,
        options: ['Yes, show me', 'Start over'],
      );
    } else if (option == 'Start over' || option == 'Back to menu') {
      state = AssistantState();
    } else {
       newHistory.add('AI: Please navigate using the bottom menu to continue.');
       state = state.copyWith(
        chatHistory: newHistory,
        options: ['Start over'],
       );
    }
  }
}

final assistantProvider = NotifierProvider<AssistantNotifier, AssistantState>(() {
  return AssistantNotifier();
});
