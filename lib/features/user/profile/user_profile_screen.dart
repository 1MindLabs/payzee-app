import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_profile.dart';
import 'package:upi_pay/features/user/dashboard/presentation/providers/citizen_profile_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  // Controllers for editable fields
  final TextEditingController _casteController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  // Initial values - in a real app these would be fetched from your user model
  String _name = "Rahul Sharma";
  String _aadharNumber = "XXXX XXXX 4532";
  String _email = "rahul.sharma@example.com";
  String _address = "123 Main Street, Bangalore, Karnataka";
  String _imageUrl = '';
   String _gender = "Male";
   String _age = "28";

  @override
  void initState() {
    super.initState();
    // Set initial values for editable fields
    updateProfile();
  }

  Future<void> updateProfile() async {
    CitizenProfile citizenProfile = ref.read(citizenProfileProvider);
    log("Citizen Profile: $citizenProfile");

    // Calculate age from DOB
    String dob = citizenProfile.personalInfo.dob;
    DateTime birthDate = DateTime.parse(dob.split('-').reversed.join('-'));
    int age = DateTime.now().year - birthDate.year;
    if (DateTime.now().isBefore(DateTime(birthDate.year, birthDate.month, birthDate.day).add(Duration(days: age * 365)))) {
      age--;
    }

    setState(() {
      _name = citizenProfile.accountInfo.name;
      _aadharNumber = citizenProfile.personalInfo.idNumber;
      _email = citizenProfile.accountInfo.email;
      _address = citizenProfile.personalInfo.address;
      _imageUrl = citizenProfile.accountInfo.imageUrl;
      _casteController.text = citizenProfile.personalInfo.caste;
      _incomeController.text =
          citizenProfile.personalInfo.annualIncome.toString();
      _occupationController.text = citizenProfile.personalInfo.occupation;
      _gender = citizenProfile.personalInfo.gender;
      _age = age.toString();
    });
  }

  @override
  void dispose() {
    _casteController.dispose();
    _incomeController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
        isDarkMode ? Colors.grey[900]! : Colors.grey[50]!;
    final Color cardColor = isDarkMode ? Colors.grey[850]! : Colors.white;
    final Color shadowColor =
        isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.1);
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color subtitleColor = Colors.grey[600]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Profile",
          // AppLocalizations.of(context)?.profile ?? "Profile",
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Handle edit profile action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _imageUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_imageUrl),
                            )
                          : Icon(Icons.person, size: 60, color: primaryColor),
                      // child: Icon(Icons.person, size: 60, color: primaryColor),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Handle image upload
                        },
                      ),
                    ),
                  ],
                ),

                Gap(24),

                // Non-editable fields section
                _buildSectionTitle(context, "Personal Information", textColor),
                Gap(16),

                // Name field (non-editable)
                _buildNonEditableField(
                  context: context,
                  label: "Name",
                  value: _name,
                  icon: Icons.person_outline,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                ),

                Gap(12),

                // Aadhar Number field (non-editable)
                _buildNonEditableField(
                  context: context,
                  label: "Aadhar Number",
                  value: _aadharNumber,
                  icon: Icons.credit_card_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                ),

                Gap(12),

                // Email field (non-editable)
                _buildNonEditableField(
                  context: context,
                  label: "Email",
                  value: _email,
                  icon: Icons.email_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                ),

                Gap(12),

                // Address field (non-editable)
                _buildNonEditableField(
                  context: context,
                  label: "Address",
                  value: _address,
                  icon: Icons.home_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                ),

                Gap(12),

                // Gender field (non-editable)
                _buildNonEditableField(
                  context: context,
                  label: "Gender",
                  value: _gender,
                  icon: Icons.person_pin_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                ),

                Gap(12),

                // Age field (non-editable)
                _buildNonEditableField(
                  context: context,
                  label: "Age",
                  value: _age,
                  icon: Icons.cake_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                ),

                Gap(24),

                // Editable fields section
                _buildSectionTitle(
                  context,
                  "Additional Information",
                  textColor,
                ),
                Gap(16),

                // Caste field (editable)
                _buildEditableField(
                  context: context,
                  label: "Caste",
                  controller: _casteController,
                  icon: Icons.group_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                  primaryColor: primaryColor,
                ),

                Gap(12),

                // Income field (editable)
                _buildEditableField(
                  context: context,
                  label: "Annual Income",
                  controller: _incomeController,
                  icon: Icons.currency_rupee_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                  primaryColor: primaryColor,
                  keyboardType: TextInputType.number,
                ),

                Gap(12),

                // Occupation field (editable)
                _buildEditableField(
                  context: context,
                  label: "Occupation",
                  controller: _occupationController,
                  icon: Icons.work_outline,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  shadowColor: shadowColor,
                  primaryColor: primaryColor,
                ),

                Gap(32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Save profile changes
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Profile updated successfully'),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    Color textColor,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildNonEditableField({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required Color shadowColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: subtitleColor, size: 24),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
                Gap(4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    required Color shadowColor,
    required Color primaryColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
                Gap(4),
                TextField(
                  controller: controller,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Enter $label',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: subtitleColor.withOpacity(0.7),
                    ),
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
