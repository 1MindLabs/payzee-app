import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _aadharController = TextEditingController();
  final _nameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  String _role = 'User';
  XFile? _aadharImage;
  bool _useImageInput = false;

  // Hardcoded values that will be set after scanning
  final String _hardcodedName = "Alfiya Fatima";
  final String _hardcodedAadhar = "7561 6481 3006";

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _aadharImage = pickedFile;
      if (pickedFile != null) {
        _useImageInput = true;
        // Set hardcoded values to controllers when image is captured
        _nameController.text = _hardcodedName;
        _aadharController.text = _hardcodedAadhar;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Logo
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.deepPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Center(
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              Center(
                child: Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),

              const SizedBox(height: 36),

              // Role selection with modern segmented control
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _role = 'User';
                            _useImageInput = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color:
                                _role == 'User'
                                    ? Colors.white
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow:
                                _role == 'User'
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'User',
                            style: TextStyle(
                              color:
                                  _role == 'User'
                                      ? Colors.black
                                      : Colors.grey.shade700,
                              fontWeight:
                                  _role == 'User'
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _role = 'Vendor';
                            _useImageInput = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color:
                                _role == 'Vendor'
                                    ? Colors.white
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow:
                                _role == 'Vendor'
                                    ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Vendor',
                            style: TextStyle(
                              color:
                                  _role == 'Vendor'
                                      ? Colors.black
                                      : Colors.grey.shade700,
                              fontWeight:
                                  _role == 'Vendor'
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Conditional inputs based on role and image input state
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        _role == 'User'
                            ? _buildUserInputs()
                            : _buildVendorInputs(),
                  ),
                ),
              ),

              // Login Button with gradient
              SizedBox(
                width: double.infinity,
                height: 42,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    if (_role == 'User') {
                      context.go('/user/dashboard');
                    } else {
                      context.go('/vendor/dashboard');
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.deepPurple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInputs() {
    if (_useImageInput && _aadharImage != null) {
      return Column(
        key: const ValueKey('userImageInput'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Capture success indicator
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Aadhaar card captured successfully',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Image with border and shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(_aadharImage!.path),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Extracted Information Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Extracted Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              // Display hardcoded name
              _buildInfoField(
                label: 'Full Name',
                value: _hardcodedName,
                icon: Icons.person,
              ),

              const SizedBox(height: 16),

              // Display hardcoded Aadhaar
              _buildInfoField(
                label: 'Aadhaar Number',
                value: _hardcodedAadhar,
                icon: Icons.credit_card,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retake Photo'),
                  onPressed: _pickImage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Manually'),
                  onPressed: () {
                    setState(() {
                      _useImageInput = false;
                      // Keep the hardcoded values in the text fields
                      _nameController.text = _hardcodedName;
                      _aadharController.text = _hardcodedAadhar;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        key: const ValueKey('userManualInput'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            textInputType: TextInputType.name,
          ),

          const SizedBox(height: 20),

          // Aadhar Field
          _buildTextField(
            controller: _aadharController,
            label: 'Aadhaar Number',
            prefixIcon: Icons.credit_card_outlined,
            textInputType: TextInputType.number,
            hintText: 'XXXX XXXX XXXX',
          ),

          const SizedBox(height: 32),

          // Divider with "or" text
          Row(
            children: [
              Expanded(
                child: Divider(color: Colors.grey.shade300, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or scan your Aadhaar',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.grey.shade300, thickness: 1),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Camera button
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                elevation: 3,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt, size: 22),
              label: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.deepPurple],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    minHeight: 48,
                  ),
                  child: const Text(
                    'Scan Aadhaar Card',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildVendorInputs() {
    return Column(
      key: const ValueKey('vendorInputs'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Name
        _buildTextField(
          controller: _businessNameController,
          label: 'Business Name',
          prefixIcon: Icons.business,
          textInputType: TextInputType.name,
        ),

        const SizedBox(height: 20),

        // GST Number
        _buildTextField(
          controller: _gstNumberController,
          label: 'GST Number',
          prefixIcon: Icons.receipt_long,
          textInputType: TextInputType.text,
          hintText: '22AAAAA0000A1Z5',
        ),

        const SizedBox(height: 20),

        // PAN Number
        _buildTextField(
          controller: _panNumberController,
          label: 'PAN Number',
          prefixIcon: Icons.article,
          textInputType: TextInputType.text,
          hintText: 'ABCDE1234F',
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    required TextInputType textInputType,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: textInputType,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon, color: Colors.deepPurple, size: 22),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
