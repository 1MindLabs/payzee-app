import 'package:flutter/material.dart';
import 'package:upi_pay/features/user/erupee-transaction/presentation/screens/erupee_screen.dart';

class VendorOrIdScreen extends StatefulWidget {
  const VendorOrIdScreen({super.key});

  @override
  State<VendorOrIdScreen> createState() => _VendorOrIdScreenState();
}

class _VendorOrIdScreenState extends State<VendorOrIdScreen> {
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Dummy vendor data with dummy account IDs
  final List<Vendor> groceryVendors = [
    Vendor(
      name: 'Big Basket',
      icon: Icons.shopping_cart,
      accountId: 'GROC12345',
    ),
    Vendor(name: 'Reliance Fresh', icon: Icons.store, accountId: 'GROC67890'),
  ];
  final List<Vendor> gasVendors = [
    Vendor(
      name: 'Bharat Gas (BPCL)',
      icon: Icons.local_gas_station,
      accountId: 'GAS54321',
    ),
    Vendor(
      name: 'HP Gas Cylinder',
      icon: Icons.local_gas_station,
      accountId: 'GAS98765',
    ),
    Vendor(
      name: 'Indane Gas',
      icon: Icons.local_gas_station,
      accountId: 'GAS19283',
    ),
  ];

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _submitAccountId() {
    if (_formKey.currentState!.validate()) {
      final id = _idController.text.trim();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoteCarouselScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Enter or Select Vendor',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 1️⃣ Manual Account ID entry
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: 'Enter Account ID',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check, color: Colors.black),
                    onPressed: _submitAccountId,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator:
                    (val) =>
                        (val == null || val.trim().isEmpty)
                            ? 'Please enter ID'
                            : null,
                onFieldSubmitted: (_) => _submitAccountId(),
              ),
            ),
          ),

          // 2️⃣ Vendor Lists
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSection('Groceries', groceryVendors),
                _buildSection('Gas Providers', gasVendors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Vendor> vendors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...vendors.map(
            (v) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(v.icon, color: Colors.black),
              ),
              title: Text(v.name, style: TextStyle(color: Colors.black)),
              onTap: () => Navigator.pop(context, v.accountId),
            ),
          ),
        ],
      ),
    );
  }
}

class Vendor {
  final String name;
  final IconData icon;
  final String accountId;
  Vendor({required this.name, required this.icon, required this.accountId});
}
