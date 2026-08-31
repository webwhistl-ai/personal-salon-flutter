import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../theme/theme.dart';
import '../../../providers/booking_flow_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/booking_model.dart';

class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key});

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  int _currentStep = 0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFlowProvider);

    if (bookingState.selectedServices.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Appointment'), backgroundColor: AppTheme.ivory),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.spa_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No services selected yet.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/services'),
                child: const Text('Browse Services'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: AppTheme.ivory,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () async {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            await _submitBooking();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : details.onStepContinue,
                    child: _isSubmitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(_currentStep == 3 ? 'Confirm Booking' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Services'),
            content: _buildServicesStep(bookingState),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Date & Time'),
            content: _buildDateTimeStep(bookingState),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Details'),
            content: _buildDetailsStep(bookingState),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Confirm'),
            content: _buildConfirmStep(bookingState),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Future<void> _submitBooking() async {
    setState(() => _isSubmitting = true);

    final bookingState = ref.read(bookingFlowProvider);
    final user = ref.read(authStateProvider).value;

    if (user == null || bookingState.selectedDate == null || bookingState.selectedTime == null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing booking details or authentication')));
       setState(() => _isSubmitting = false);
       return;
    }

    try {
      final bookingId = const Uuid().v4();
      final date = bookingState.selectedDate!;
      // Simple time parsing for mock purposes
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
        notes: bookingState.notes,
        createdAt: DateTime.now(),
      );

      await ref.read(bookingRepositoryProvider).createBooking(booking);
      ref.read(bookingFlowProvider.notifier).clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Confirmed!'), backgroundColor: Colors.green));
        context.go('/profile');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildServicesStep(BookingFlowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...state.selectedServices.map((service) => ListTile(
          title: Text(service.name),
          subtitle: Text('₹${service.price.toStringAsFixed(0)} • ${service.durationMinutes} mins'),
          trailing: IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () {
            ref.read(bookingFlowProvider.notifier).removeService(service.id);
          }),
          contentPadding: EdgeInsets.zero,
        )),
        TextButton.icon(
          onPressed: () => context.go('/services'),
          icon: const Icon(Icons.add),
          label: const Text('Add more services'),
        ),
      ],
    );
  }

  Widget _buildDateTimeStep(BookingFlowState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = state.selectedDate?.day == date.day && state.selectedDate?.month == date.month;

              return GestureDetector(
                onTap: () => ref.read(bookingFlowProvider.notifier).setDate(date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.deepPlum : Colors.white,
                    border: Border.all(color: isSelected ? AppTheme.deepPlum : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('MMM').format(date), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                      Text('${date.day}', style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text('Select Time', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _timeChip('10:00 AM', state.selectedTime == '10:00 AM'),
            _timeChip('11:00 AM', state.selectedTime == '11:00 AM'),
            _timeChip('02:00 PM', state.selectedTime == '02:00 PM'),
            _timeChip('04:00 PM', state.selectedTime == '04:00 PM'),
          ],
        )
      ],
    );
  }

  Widget _timeChip(String time, bool isSelected) {
    return ChoiceChip(
      label: Text(time),
      selected: isSelected,
      onSelected: (val) {
        if (val) ref.read(bookingFlowProvider.notifier).setTime(time);
      },
      selectedColor: AppTheme.roseGold.withAlpha(50),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildDetailsStep(BookingFlowState state) {
    return Column(
      children: [
        TextField(
          onChanged: (val) => ref.read(bookingFlowProvider.notifier).setNotes(val),
          decoration: const InputDecoration(
            labelText: 'Special requests or notes',
            hintText: 'e.g., Sensitive skin, prefer quiet session...',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
              SizedBox(height: 8),
              Text('Upload Inspiration Photo (Optional)', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmStep(BookingFlowState state) {
    final dateStr = state.selectedDate != null ? DateFormat('MMM d, yyyy').format(state.selectedDate!) : 'Not selected';
    final timeStr = state.selectedTime ?? 'Not selected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Services'), Flexible(child: Text('${state.selectedServices.length} items', textAlign: TextAlign.right))]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Date & Time'), Text('$dateStr, $timeStr')]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Duration'), Text('${state.totalDuration} mins')]),
        const Divider(height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text('₹${state.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.deepPlum)),
        ]),
        const SizedBox(height: 16),
        const Text('Payment will be collected at the venue.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      ],
    );
  }
}
