import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../repositories/booking_repository.dart';

class BookingFlowState {
  final List<ServiceModel> selectedServices;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String notes;

  BookingFlowState({
    this.selectedServices = const [],
    this.selectedDate,
    this.selectedTime,
    this.notes = '',
  });

  BookingFlowState copyWith({
    List<ServiceModel>? selectedServices,
    DateTime? selectedDate,
    String? selectedTime,
    String? notes,
  }) {
    return BookingFlowState(
      selectedServices: selectedServices ?? this.selectedServices,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => selectedServices.fold(0, (sum, s) => sum + s.price);
  int get totalDuration => selectedServices.fold(0, (sum, s) => sum + s.durationMinutes);
}

class BookingFlowNotifier extends Notifier<BookingFlowState> {
  @override
  BookingFlowState build() {
    return BookingFlowState();
  }

  void addService(ServiceModel service) {
    if (!state.selectedServices.any((s) => s.id == service.id)) {
      state = state.copyWith(selectedServices: [...state.selectedServices, service]);
    }
  }

  void removeService(String serviceId) {
    state = state.copyWith(
      selectedServices: state.selectedServices.where((s) => s.id != serviceId).toList(),
    );
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTime(String time) {
    state = state.copyWith(selectedTime: time);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void clear() {
    state = BookingFlowState();
  }
}

final bookingFlowProvider = NotifierProvider<BookingFlowNotifier, BookingFlowState>(() {
  return BookingFlowNotifier();
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});
