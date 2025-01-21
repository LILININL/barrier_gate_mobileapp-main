import 'package:barrier_gate/rpp/add_checkpion_list_view/add_checkpion_list_view_widget.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/visitorcarregistration_widget.dart';
import 'package:get/get.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'scan_q_r_code_checkpion_model.dart';
export 'scan_q_r_code_checkpion_model.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCodeCheckpionWidget extends StatefulWidget {
  ScanQRCodeCheckpionWidget({super.key});

  @override
  State<ScanQRCodeCheckpionWidget> createState() =>
      _ScanQRCodeCheckpionWidgetState();
}

class _ScanQRCodeCheckpionWidgetState extends State<ScanQRCodeCheckpionWidget>
    with TickerProviderStateMixin {
  late ScanQRCodeCheckpionModel _model;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final animationsMap = <String, AnimationInfo>{};
  QRViewController? qrController;
  bool isProcessing = false;

  String? qrCodeValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanQRCodeCheckpionModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 2000.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });

    // ฟังข้อมูลจากการสแกน QR Code
    controller.scannedDataStream.listen((scanData) {
      if (!isProcessing) {
        setState(() {
          isProcessing = true;
        });

        _processQRCode(scanData.code);
      }
    });
  }

  Future<void> _processQRCode(String? qrCode) async {
    if (qrCode == null) return;

    try {
      // แปลงข้อมูลจาก QR Code เป็น JSON
      final decodedData = jsonDecode(qrCode);

      // ตรวจสอบและดึงค่าที่จำเป็น
      final qrLocationId = decodedData['qr_location_id'].toString();
      final villageProjectId = decodedData['villageproject_id'].toString();
      final locationName = decodedData['location_name'].toString();
      final latitude = decodedData['latitude'] != null
          ? double.tryParse(decodedData['latitude'].toString())
          : null;
      final longitude = decodedData['longitude'] != null
          ? double.tryParse(decodedData['longitude'].toString())
          : null;

      if (qrLocationId != null &&
          villageProjectId != null &&
          locationName != null &&
          latitude != null &&
          longitude != null) {
        // เปลี่ยนหน้าและส่งข้อมูล
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCheckpionListViewWidget(
                qrLocationId: qrLocationId.toString(),
                villageProjectId: villageProjectId.toString(),
                locationName: locationName.toString(),
                latitude: latitude,
                isEditMode: false,
                longitude: longitude),
          ),
        );
        setState(() {});
      } else {
        print('Invalid QR Code: Missing required fields');
      }
    } catch (e) {
      print('Error decoding QR Code: $e');
    }

    // หน่วงเวลาเพื่อป้องกันการสแกนซ้ำ
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isProcessing = false;
    });
    qrController?.resumeCamera();
  }

  @override
  void dispose() {
    _model.dispose();
    qrController?.pauseCamera();
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // ทำพื้นหลังโปร่งใส
      body: Stack(
        children: [
          // QR View กล้องแบบเต็มหน้าจอ
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            cameraFacing: CameraFacing.back,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.green, // สีของกรอบ QR Code
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 350, // ขนาดของกรอบสแกน
            ),
          ),
          // เส้นสีเขียวตัดกลางจอ
          Positioned.fill(
            child: CustomPaint(
              painter: LinePainter(), // ใช้ CustomPainter สำหรับวาดเส้น
            ),
          ),
          // ส่วนหัวด้านบน
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5), // เพิ่มความโปร่งใส
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 48), // ช่องว่างเท่าขนาดปุ่มย้อนกลับ
                ],
              ),
            ),
          ),
          // แสดงข้อความด้านล่าง
          // Align(
          //   alignment: AlignmentDirectional(0.0, 1.0),
          //   child: Padding(
          //     padding: EdgeInsets.all(32.0),
          //     child: Container(
          //       width: 70.0,
          //       height: 70.0,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         border: Border.all(
          //           color: FlutterFlowTheme.of(context).primaryBackground,
          //         ),
          //       ),
          //       child: Align(
          //         alignment: AlignmentDirectional(0.0, 0.0),
          //         child: FlutterFlowIconButton(
          //           borderColor: Colors.transparent,
          //           borderRadius: 100.0,
          //           buttonSize: 64.0,
          //           fillColor: FlutterFlowTheme.of(context).secondaryBackground,
          //           icon: Icon(
          //             Icons.qr_code_scanner,
          //             color: FlutterFlowTheme.of(context).primaryText,
          //             size: 24.0,
          //           ),
          //           onPressed: () async {
          //             context.pushNamed('add_checkpion_list_view');
          //           },
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green // สีของเส้น
      ..strokeWidth = 2.0 // ความหนาของเส้น
      ..style = PaintingStyle.stroke;

    // จุดกึ่งกลางของหน้าจอ
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // ความยาวของเส้น
    final double lineLength = 170.0; // ปรับความยาวของเส้นตามต้องการ

    // // เส้นแนวตั้ง
    // final verticalStart = Offset(centerX, centerY - lineLength); // เริ่มต้น
    // final verticalEnd = Offset(centerX, centerY + lineLength); // สิ้นสุด
    // canvas.drawLine(verticalStart, verticalEnd, paint);

    // เส้นแนวนอน
    final horizontalStart = Offset(centerX - lineLength, centerY); // เริ่มต้น
    final horizontalEnd = Offset(centerX + lineLength, centerY); // สิ้นสุด
    canvas.drawLine(horizontalStart, horizontalEnd, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // ไม่ต้อง Repaint หากไม่มีการเปลี่ยนแปลง
  }
}
