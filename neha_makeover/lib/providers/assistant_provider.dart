import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'booking_flow_provider.dart';
import 'auth_provider.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import 'service_provider.dart';

enum AssistantStep {
  initial,
  bookingOccasion,
  serviceSelection,
  dateSelection,
  timeSelection,
  confirmBooking,
  priceCheck,
  faq
}

class AssistantState {
  final AssistantStep currentStep;
  final List<String> chatHistory; // simple log of AI messages
  final List<String> options;
  final bool isProcessing;
  final ServiceModel? pendingService; // Temporarily hold the selected service

  AssistantState({
    this.currentStep = AssistantStep.initial,
    this.chatHistory = const ['Hi! I am your Neha Makeover concierge. How can I help you today?'],
    this.options = const ['Book an appointment', 'Check prices', 'Ask a question'],
    this.isProcessing = false,
    this.pendingService,
  });

  AssistantState copyWith({
    AssistantStep? currentStep,
    List<String>? chatHistory,
    List<String>? options,
    bool? isProcessing,
    ServiceModel? pendingService,
  }) {
    return AssistantState(
      currentStep: currentStep ?? this.currentStep,
      chatHistory: chatHistory ?? this.chatHistory,
      options: options ?? this.options,
      isProcessing: isProcessing ?? this.isProcessing,
      pendingService: pendingService ?? this.pendingService,
    );
  }
}

class AssistantNotifier extends Notifier<AssistantState> {
  @override
  AssistantState build() {
    return AssistantState();
  }

  void handleOptionSelected(String option) async {
    List<String> newHistory = List.from(state.chatHistory)..add('You: $option');

    if (option == 'Start over' || option == 'Back to menu') {
      state = AssistantState();
      ref.read(bookingFlowProvider.notifier).clear();
      return;
    }

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
      newHistory.add('AI: Perfect. For $option, I have found some popular services. Which one would you like?');

      // Fetch popular services directly from Riverpod
      final asyncServices = ref.read(servicesProvider);

      state = state.copyWith(
        currentStep: AssistantStep.serviceSelection,
        chatHistory: newHistory,
        isProcessing: true,
        options: [],
      );

      // We need to wait for services to load if they haven't
      if (asyncServices.hasValue) {
        _presentServices(asyncServices.value!, newHistory);
      } else {
        // Simple delay to allow stream to fetch in MVP
        await Future.delayed(const Duration(seconds: 1));
        final updatedServices = ref.read(servicesProvider).value ?? [];
        _presentServices(updatedServices, newHistory);
      }

    } else if (state.currentStep == AssistantStep.serviceSelection) {
      final asyncServices = ref.read(servicesProvider).value ?? [];
      // Find the selected service
      final selectedService = asyncServices.firstWhere(
        (s) => s.name == option,
        orElse: () => asyncServices.first,
      );

      ref.read(bookingFlowProvider.notifier).addService(selectedService);

      newHistory.add('AI: Excellent choice. When would you like to come in? (Pick a date for next week)');

      // Generate some dummy dates
      final today = DateTime.now();
      final dates = [
        DateFormat('MMM d').format(today.add(const Duration(days: 1))),
        DateFormat('MMM d').format(today.add(const Duration(days: 2))),
        DateFormat('MMM d').format(today.add(const Duration(days: 3))),
      ];

      state = state.copyWith(
        currentStep: AssistantStep.dateSelection,
        chatHistory: newHistory,
        pendingService: selectedService,
        options: dates,
      );

    } else if (state.currentStep == AssistantStep.dateSelection) {
      // Create a dummy date based on selection (for mock flow)
      final dummyDate = DateTime.now().add(const Duration(days: 1)); // We'll just fake the actual day for the MVP AI flow
      ref.read(bookingFlowProvider.notifier).setDate(dummyDate);

      newHistory.add('AI: Got it. What time works best for you?');
      state = state.copyWith(
        currentStep: AssistantStep.timeSelection,
        chatHistory: newHistory,
        options: ['10:00 AM', '01:00 PM', '04:00 PM', '06:00 PM'],
      );

    } else if (state.currentStep == AssistantStep.timeSelection) {
      ref.read(bookingFlowProvider.notifier).setTime(option);
      final bookingState = ref.read(bookingFlowProvider);

      newHistory.add('AI: Perfect. You are booking ${state.pendingService?.name ?? 'a service'} for ₹${bookingState.totalPrice.toStringAsFixed(0)}. Shall I confirm this appointment?');
      state = state.copyWith(
        currentStep: AssistantStep.confirmBooking,
        chatHistory: newHistory,
        options: ['Yes, confirm', 'Start over'],
      );

    } else if (state.currentStep == AssistantStep.confirmBooking) {
      if (option == 'Yes, confirm') {
        state = state.copyWith(
          isProcessing: true,
          chatHistory: List.from(newHistory)..add('AI: Processing your booking...'),
          options: [],
        );

        await _finalizeBooking();
      }
    } else {
       newHistory.add('AI: Please navigate using the bottom menu to continue.');
       state = state.copyWith(
        chatHistory: newHistory,
        options: ['Start over'],
       );
    }
  }

  void _presentServices(List<ServiceModel> services, List<String> history) {
    final popularOptions = services.where((s) => s.isPopular).take(4).map((s) => s.name).toList();
    if (popularOptions.isEmpty) popularOptions.add('Signature Bridal Glow'); // Fallback

    state = state.copyWith(
      isProcessing: false,
      chatHistory: history,
      options: [...popularOptions, 'Start over'],
    );
  }

  Future<void> _finalizeBooking() async {
    final bookingState = ref.read(bookingFlowProvider);
    final user = ref.read(authStateProvider).value;
    List<String> history = List.from(state.chatHistory);

    if (user == null || bookingState.selectedDate == null || bookingState.selectedTime == null) {
       history.add('AI: Oops! It looks like you are not logged in, or we missed some details. Please go to the Profile screen to log in first.');
       state = state.copyWith(isProcessing: false, chatHistory: history, options: ['Start over']);
       return;
    }

    try {
      final bookingId = const Uuid().v4();
      final date = bookingState.selectedDate!;
      int hour = int.parse(bookingState.selectedTime!.split(':')[0]);
      if (bookingState.selectedTime!.contains('PM') && hour != 12) hour += 12;

      final bookingDateTime = DateTime(date.year, date.month, date.day, hour, 0);

      final booking = BookingModel(
        id: bookingId,
        customerId: user.uid,
        serviceIds: bookingState.selectedServices.map((s) => s.id).toList(),
        dateTime: bookingDateTime,
        totalDurationMinutes: bookingState.totalDuration,
        totalPrice: bookingState.totalPrice,
        notes: "Booked via AI Assistant",
        createdAt: DateTime.now(),
      );

      await ref.read(bookingRepositoryProvider).createBooking(booking);
      ref.read(bookingFlowProvider.notifier).clear();

      history.add('AI: All set! Your booking is confirmed. You can view the details in your Profile. Have a beautiful day!');
      state = state.copyWith(
        isProcessing: false,
        chatHistory: history,
        options: ['Book another', 'Back to menu'],
        currentStep: AssistantStep.initial,
      );

    } catch (e) {
      history.add('AI: Sorry, something went wrong saving your booking. Please try again.');
      state = state.copyWith(isProcessing: false, chatHistory: history, options: ['Start over']);
    }
  }
}

final assistantProvider = NotifierProvider<AssistantNotifier, AssistantState>(() {
  return AssistantNotifier();
});
