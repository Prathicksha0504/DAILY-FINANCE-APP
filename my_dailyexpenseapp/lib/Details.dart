import 'package:flutter/material.dart';
import 'package:my_dailyexpenseapp/Dashboard.dart';

class UserDetailsScreen extends StatefulWidget {
  final String phoneNumber;

  const UserDetailsScreen({super.key, required this.phoneNumber});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _monthlyBudgetController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _monthlyBudgetController.dispose();
    super.dispose();
  }

  void _saveUserDetails() {
    if (_formKey.currentState!.validate()) {
      // Parse monthly budget
      double monthlyBudget = double.parse(_monthlyBudgetController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details saved for ${_nameController.text}'),
        ),
      );

      // Navigate to Dashboard with monthly budget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            monthlyBudget: monthlyBudget,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the build method remains the same as in your previous code
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Phone Number Field (Read-Only)
                TextFormField(
                  initialValue: widget.phoneNumber,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field with Gmail-specific validation
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Gmail Address',
                    hintText:
                        'Username can have uppercase, domain must be lowercase',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }

                    // Specific validation for Gmail
                    // Allows uppercase in local part, but requires lowercase gmail.com
                    RegExp gmailRegex = RegExp(
                        r'^[A-Za-z0-9]+[\._]?[A-Za-z0-9]+[@](gmail)\.com$');

                    if (!gmailRegex.hasMatch(value)) {
                      return 'Please use a valid lowercase gmail.com email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Monthly Budget Field
                TextFormField(
                  controller: _monthlyBudgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monthly Budget',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your monthly budget';
                    }
                    // Check if the input is a valid number
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Save Details Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveUserDetails,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save Details'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}