import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final CitizenTransaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Determine if money was sent or received
    final bool isIncoming = transaction.txType == 'government-to-citizen';
    final String transactionTypeText = isIncoming ? 'Received' : 'Sent';
    final Color amountColor = isIncoming ? Colors.green.shade600 : Colors.red.shade600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Transaction amount and status section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Amount display
                  Text(
                    '₹${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: amountColor,
                    ),
                  ),
                  SizedBox(height: 12),

                  // Transaction type and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$transactionTypeText · ${transaction.status}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        transaction.status == 'Completed'
                            ? Icons.check_circle
                            : Icons.pending,
                        size: 18,
                        color: transaction.status == 'Completed'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Date and time
                  Text(
                    DateFormat('MMMM d, yyyy • h:mm a').format(transaction.timestamp),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Transaction details section
            _buildSectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'DETAILS',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Transaction ID
                  _buildDetailRow('Transaction ID', transaction.id),

                  // From/To information
                  _buildDetailRow(
                    isIncoming ? 'From' : 'To',
                    isIncoming ? transaction.fromId : transaction.toId,
                  ),

                  // Description
                  _buildDetailRow('Description', transaction.description),

                  // Scheme ID (if applicable)
                  if (transaction.schemeId != null)
                    _buildDetailRow('Scheme ID', transaction.schemeId!),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Actions section
            _buildSectionContainer(
              child: Column(
                children: [
                  _buildElevatedButton(
                    onPressed: () {
                      // Share transaction details
                      
                    },
                    icon: Icons.share,
                    label: 'Share receipt',
                    color: Colors.blue.shade600,
                  ),
                  SizedBox(height: 12),
                  _buildTextButton(
                    onPressed: () {
                      // Report an issue logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report feature coming soon')),
                      );
                    },
                    icon: Icons.report_problem_outlined,
                    label: 'Report an issue',
                    color: Colors.red.shade700,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Additional info section - inspired by eRupee wallet UI
            _buildSectionContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'SCHEME INFORMATION',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  // Scheme validity info
                  if (transaction.schemeId != null)
                    _buildInfoRow(
                      'Validity',
                      '180 days from receipt',
                      Icons.calendar_today,
                      Colors.blue.shade100,
                      Colors.blue.shade600,
                    ),
                    
                  // Utilization info
                  if (isIncoming)
                    _buildInfoRow(
                      'Utilization',
                      'Education expenses only',
                      Icons.school,
                      Colors.purple.shade100,
                      Colors.purple.shade600,
                    ),
                    
                  // Location info
                  _buildInfoRow(
                    'Accepted at',
                    'All authorized merchants',
                    Icons.location_on,
                    Colors.orange.shade100,
                    Colors.orange.shade600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Floating action button - inspired by eRupee wallet
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 56,
        width: 180,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue.shade600,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment functionality coming soon')),
            );
          },
          icon: Icon(Icons.payment),
          label: Text(
            "Payment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Helper method to build styled container sections
  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Helper method to build detail rows with modern styling
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label, 
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value, 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build info row with icon
  Widget _buildInfoRow(
    String title, 
    String value, 
    IconData icon, 
    Color iconBgColor,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build elevated buttons with modern styling
  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
    );
  }
  
  // Helper method to build text buttons with modern styling
  Widget _buildTextButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
      ),
      label: Text(
        label,
        style: TextStyle(color: color),
      ),
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}