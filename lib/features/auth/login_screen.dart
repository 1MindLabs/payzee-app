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

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _aadharImage = pickedFile;
      if (pickedFile != null) {
        _useImageInput = true;
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
              // Logo or App Icon (Apple Pay-like)
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Role selection with Apple Pay styled segmented control
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
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
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _role == 'User'
                                    ? Colors.white
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
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
                              fontWeight: FontWeight.w500,
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
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                _role == 'Vendor'
                                    ? Colors.white
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
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
                              fontWeight: FontWeight.w500,
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

              // Login Button - Apple Pay style
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // More rounded like Apple Pay
                    ),
                    elevation: 0, // Flat appearance
                  ),
                  onPressed: () {
                    if (_role == 'User') {
                      context.go('/user/dashboard');
                    } else {
                      context.go('/vendor/dashboard');
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(_aadharImage!.path),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retake Photo'),
            onPressed: _pickImage,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsetsDirectional.zero,
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            icon: const Icon(Icons.keyboard, size: 18),
            label: const Text('Enter Details Manually'),
            onPressed: () {
              setState(() {
                _useImageInput = false;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsetsDirectional.zero,
            ),
          ),
        ],
      );
    } else {
      return Column(
        key: const ValueKey('userManualInput'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          _buildApplePayTextField(
            controller: _nameController,
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            textInputType: TextInputType.name,
          ),

          const SizedBox(height: 16),

          // Aadhar Field
          _buildApplePayTextField(
            controller: _aadharController,
            label: 'Aadhaar Number',
            prefixIcon: Icons.credit_card_outlined,
            textInputType: TextInputType.number,
          ),

          const SizedBox(height: 24),

          // Divider with "or" text
          Row(
            children: [
              Expanded(
                child: Divider(color: Colors.grey.shade300, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.grey.shade300, thickness: 1),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Camera button
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt_outlined, size: 18),
              label: const Text(
                'Scan Aadhaar Card',
                style: TextStyle(fontWeight: FontWeight.w500),
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
        _buildApplePayTextField(
          controller: _businessNameController,
          label: 'Business Name',
          prefixIcon: Icons.business_outlined,
          textInputType: TextInputType.name,
        ),

        const SizedBox(height: 16),

        // GST Number
        _buildApplePayTextField(
          controller: _gstNumberController,
          label: 'GST Number',
          prefixIcon: Icons.receipt_outlined,
          textInputType: TextInputType.text,
        ),

        const SizedBox(height: 16),

        // PAN Number
        _buildApplePayTextField(
          controller: _panNumberController,
          label: 'PAN Number',
          prefixIcon: Icons.card_membership_outlined,
          textInputType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildApplePayTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    required TextInputType textInputType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: textInputType,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.grey.shade700,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
