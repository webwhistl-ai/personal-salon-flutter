import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: AppTheme.ivory,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            // Confirm booking
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
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Confirm Booking' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
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
            content: _buildServicesStep(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Date & Time'),
            content: _buildDateTimeStep(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Details'),
            content: _buildDetailsStep(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Confirm'),
            content: _buildConfirmStep(),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Bridal Makeup'),
          subtitle: const Text('₹15,000 • 3 hrs'),
          trailing: IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {}),
          contentPadding: EdgeInsets.zero,
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add more services'),
        ),
      ],
    );
  }

  Widget _buildDateTimeStep() {
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
              final isSelected = index == 2;
              return Container(
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
                    Text('Oct', style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                    Text('${15 + index}', style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
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
            _timeChip('10:00 AM', false),
            _timeChip('11:00 AM', true),
            _timeChip('02:00 PM', false),
            _timeChip('04:00 PM', false),
          ],
        )
      ],
    );
  }

  Widget _timeChip(String time, bool isSelected) {
    return ChoiceChip(
      label: Text(time),
      selected: isSelected,
      onSelected: (val) {},
      selectedColor: AppTheme.roseGold.withAlpha(50),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
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

  Widget _buildConfirmStep() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Services'), Text('Bridal Makeup')]),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Date & Time'), Text('Oct 17, 11:00 AM')]),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Duration'), Text('3 Hours')]),
        Divider(height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text('₹15,000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.deepPlum)),
        ]),
        SizedBox(height: 16),
        Text('Payment will be collected at the venue.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      ],
    );
  }
}
