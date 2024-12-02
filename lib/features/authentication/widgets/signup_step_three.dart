
import 'package:flutter/material.dart';

class SignupStepThree extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) onPlanSelected;

  const SignupStepThree({
    super.key,
    required this.formKey,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Plan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Monthly Subscription'),
            leading: Radio<String>(
              value: 'monthly',
              groupValue: null, // You'll need to manage this state
              onChanged: (value) => onPlanSelected(value!),
            ),
          ),
          ListTile(
            title: const Text('Annual Subscription'),
            leading: Radio<String>(
              value: 'annual',
              groupValue: null, // You'll need to manage this state
              onChanged: (value) => onPlanSelected(value!),
            ),
          ),
          ListTile(
            title: const Text('Commission-based'),
            leading: Radio<String>(
              value: 'commission',
              groupValue: null, // You'll need to manage this state
              onChanged: (value) => onPlanSelected(value!),
            ),
          ),
        ],
      ),
    );
  }
}