import 'package:flutter/material.dart';
import '../models/student.dart';
import 'profile_screen.dart';
import '../widgets/profile_picture_picker.dart';

class RegistrationScreen extends StatefulWidget {
  final Student? existingStudent;
  const RegistrationScreen({super.key, this.existingStudent});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime? _selectedDate;
  String _gender = 'Male';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.existingStudent != null) {
      _nameController.text = widget.existingStudent!.fullName;
      _emailController.text = widget.existingStudent!.email;
      _contactController.text = widget.existingStudent!.contactNumber;
      _selectedDate = widget.existingStudent!.dateOfBirth;
      _gender = widget.existingStudent!.gender;
      _profileImagePath = widget.existingStudent!.profileImagePath;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final student = Student(
        fullName: _nameController.text,
        email: _emailController.text,
        contactNumber: _contactController.text,
        dateOfBirth: _selectedDate!,
        gender: _gender,
        profileImagePath: _profileImagePath,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile submitted successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen(student: student)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly!')),
      );
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ProfilePicturePicker(
                        onImagePicked: (path) => _profileImagePath = path,
                        initialImage: _profileImagePath,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty ? 'Enter full name' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value!.contains('@')
                                    ? null
                                    : 'Enter valid email',
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Contact Number',
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value!.length == 10
                                    ? null
                                    : 'Enter 10-digit number',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'Date of Birth: Not selected'
                                  : 'DOB: ${_selectedDate!.toLocal()}'.split(
                                    ' ',
                                  )[0],
                            ),
                          ),
                          TextButton(
                            onPressed: _pickDate,
                            child: const Text('Select Date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        items:
                            ['Male', 'Female', 'Other']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) => setState(() => _gender = value!),
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
