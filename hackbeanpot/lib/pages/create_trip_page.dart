import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _tripNameController = TextEditingController();
  final _startLocationController = TextEditingController();
  final _endLocationController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemBackground,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.xmark,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Trip',
          style: TextStyle(
            color: CupertinoColors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CupertinoButton(
            child: const Text('Create'),
            onPressed: () {
              // TODO: Implement trip creation
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Name Field
              _buildSectionTitle('Trip Name'),
              CupertinoTextField(
                controller: _tripNameController,
                placeholder: 'Enter trip name',
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
              ),
              const SizedBox(height: 24),

              // Locations Section
              _buildSectionTitle('Locations'),
              CupertinoTextField(
                controller: _startLocationController,
                placeholder: 'Start location',
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.location_solid, size: 20),
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _endLocationController,
                placeholder: 'End location',
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.location_solid, size: 20),
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
              ),
              const SizedBox(height: 24),

              // Dates Section
              _buildSectionTitle('Dates'),
              GestureDetector(
                onTap: () => _showDatePicker(context, true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Date'),
                      Text(
                        '${_startDate.month}/${_startDate.day}/${_startDate.year}',
                        style:
                            const TextStyle(color: CupertinoColors.activeBlue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showDatePicker(context, false),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('End Date'),
                      Text(
                        '${_endDate.month}/${_endDate.day}/${_endDate.year}',
                        style:
                            const TextStyle(color: CupertinoColors.activeBlue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, bool isStartDate) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: isStartDate ? _startDate : _endDate,
            mode: CupertinoDatePickerMode.date,
            use24hFormat: true,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                if (isStartDate) {
                  _startDate = newDate;
                } else {
                  _endDate = newDate;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tripNameController.dispose();
    _startLocationController.dispose();
    _endLocationController.dispose();
    super.dispose();
  }
}
