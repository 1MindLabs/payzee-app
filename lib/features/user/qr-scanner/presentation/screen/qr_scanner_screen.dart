import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  String? scannedResult;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _toggleFlash() async {
    await controller?.toggleFlash();
    setState(() {});
  }

  void _uploadFromGallery() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Gallery upload coming soon!')));
  }

  void _showScannedResultDialog(String? code) {
    if (code == null) return;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Scanned QR Code'),
            content: Text(code),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller?.resumeCamera();
                },
                child: Text('Scan Again'),
              ),
            ],
          ),
    );
    controller?.pauseCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: (QRViewController controller) {
                        this.controller = controller;
                        controller.scannedDataStream.listen((data) {
                          if (mounted) {
                            setState(() {
                              scannedResult = data.code;
                            });
                          }
                          _showScannedResultDialog(data.code);
                        });
                      },
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.orange,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 8,
                        cutOutSize: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 70,
                      child: IconButton(
                        icon: Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _toggleFlash,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.qr_code,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _uploadFromGallery,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child:
                    Container(), // Just empty space to leave for bottom sheet
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.14,
            minChildSize: 0.14,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Scan any QR code to pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Google Pay • PhonePe • PayTM • Authorized Vendors',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 30),
                        Icon(
                          Icons.qr_code_scanner,
                          size: 100,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Scan any QR code, not just Google Pay\'s.\nPosition your phone to make sure the QR code is within the frame.',
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See all supported QR codes',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
