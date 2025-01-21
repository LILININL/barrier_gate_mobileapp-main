import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_endpoint.dart';
import 'package:barrier_gate/function_untils/controller/01BR_MB_VillageProject__controller.dart';
import 'package:barrier_gate/function_untils/controller/villageproject_register_qr_controller.dart';
import 'package:barrier_gate/function_untils/model/01BR_MB_VillageProject__model.dart';
import 'package:barrier_gate/function_untils/model/villageproject_register_qr_model.dart';
import 'package:barrier_gate/home/check_infomation_list_view/check_infomation_list_view_widget.dart';
import 'package:barrier_gate/utils/popup_issue/popup_issue_widget.dart';
import 'package:barrier_gate/utils/popup_loading/popup_loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'scan_q_r_code_model.dart';
export 'scan_q_r_code_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCodeWidget extends StatefulWidget {
  const ScanQRCodeWidget({super.key});

  @override
  State<ScanQRCodeWidget> createState() => _ScanQRCodeWidgetState();
}

class _ScanQRCodeWidgetState extends State<ScanQRCodeWidget>
    with TickerProviderStateMixin {
  late ScanQRCodeModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};
  late SharedPreferences prefs;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String? officerID;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScanQRCodeModel());

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
    doGetSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  doGetSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    officerID = await prefs.getString('officer_id');
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
  }

  @override
  void dispose() {
    _model.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFBBF4F6),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x5AF5F5F5), Color(0x00FFFFFF)],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(0.0, -1.0),
                      end: AlignmentDirectional(0, 1.0),
                    ),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, -1.0),
                    child: Container(
                      width: double.infinity,
                      height: 90.0,
                      decoration: BoxDecoration(),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 20.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  size: 20.0,
                                ),
                                onPressed: () async {
                                  context.safePop();
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: 48.0,
                                decoration: BoxDecoration(),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'QR Code',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .titleMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .titleMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(),
                            ),
                          ]
                              .divide(SizedBox(width: 16.0))
                              .around(SizedBox(width: 16.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'คุณสามารถเข้าร่วมโครงการโดยการแสกนคิวอาร์โค้ด',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w300,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Container(
                                width: 300.0,
                                height: 300.0,
                                child: QRView(
                                  key: qrKey,
                                  onQRViewCreated: _onQRViewCreated,
                                  overlay: QrScannerOverlayShape(
                                    borderColor: Colors.white,
                                    borderRadius: 10,
                                    borderLength: 30,
                                    borderWidth: 10,
                                    cutOutSize: 300,
                                  ),
                                ))
                            // .animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                            ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 100.0,
                                buttonSize: 64.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                icon: Icon(
                                  Icons.qr_code_scanner,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  // await BrMbVillageProjectModel01Controller.getBrMbVillageProjectModel01s('').then((value) {
                                  //   print('object' + value[0].villageproject_id.toString());
                                  // });
                                  // context.pushNamed('check_infomation_list_view');
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      print('QR Code: ${scanData.code}');
      if (scanData.code!.toString() != '') {
        try {
          controller.pauseCamera();
          String qrData = decryptMyData(scanData.code!.toString());
          print('decryptMyData := ' + qrData);
          Map<String, dynamic> jsonData = jsonDecode(qrData);

          int villageprojectDetailId =
              int.parse(jsonData['villageproject_detail_id']);

          // ตรวจสอบว่ามี villageproject_detail_id นี้ในระบบหรือไม่
          bool isDuplicate =
              await VillageprojectRegisterQrController.checkDuplicateByDetailId(
                  villageprojectDetailId, int.parse(officerID!));

          if (isDuplicate) {
            // เปิด Modal เพื่อแจ้งเตือน
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                // ใช้ Builder เพื่อสร้าง Context ใหม่เฉพาะ Modal นี้
                return Builder(
                  builder: (modalContext) {
                    // Modal UI
                    return Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: PopupIssueWidget(
                        messageIssue:
                            "ท่านได้ลงทะเบียนเข้าร่วมโครงการและบ้านเลขที่นี้ไปแล้ว",
                      ),
                    );
                  },
                );
              },
            ).then((_) {
              // Resume camera หลังจาก Modal ถูกปิด
              controller.resumeCamera();
            });

            // ใช้ Future.delayed เพื่อปิด Modal หลังจากแสดงผล 2 วินาที
            Future.delayed(Duration(seconds: 2), () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context); // ปิด Modal
                context.goNamed('home_list_view'); // นำผู้ใช้กลับหน้าหลัก
              }
            });

            return; // ยุติการทำงาน
          }

          // แสดง Popup Loading ขณะบันทึก
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: PopupLoadingWidget(),
              );
            },
          ).then((value) => safeSetState(() {}));

          // เรียก API บันทึก QR ใหม่
          await VillageprojectRegisterQrController
                  .getVillageprojectRegisterQrFromID(
                      int.parse(jsonData['villageproject_register_qr_id']))
              .then((value) async {
            late VillageprojectRegisterQr villageprojectRegisterQrModal = value;

            if (villageprojectRegisterQrModal.qr_is_use == null ||
                villageprojectRegisterQrModal.qr_is_use
                    .toString()
                    .trim()
                    .isEmpty) {
              villageprojectRegisterQrModal.qr_is_use = 'Y';
              villageprojectRegisterQrModal.qr_use_datetime = DateTime.now();
              villageprojectRegisterQrModal.officer_id = int.parse(officerID!);
              villageprojectRegisterQrModal.uuid = "";

              await VillageprojectRegisterQrController
                      .saveVillageprojectRegisterQr(
                          villageprojectRegisterQrModal)
                  .then((value) async {
                controller.resumeCamera();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckInfomationListViewWidget(
                      villageproject_detail_id: villageprojectDetailId,
                      officerID: int.parse(officerID!),
                    ),
                  ),
                );
              });
            } else {
              Navigator.pop(context);
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: PopupIssueWidget(
                        messageIssue: "QR ถูกใช้ลงทะเบียนแล้ว"),
                  );
                },
              ).then((value) => safeSetState(() {}));
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pop(context);
                controller.resumeCamera();
              });
            }
          });
        } catch (e) {
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: PopupIssueWidget(
                    messageIssue: "QR ไม่ถูกต้อง Error " + e.toString()),
              );
            },
          ).then((value) => safeSetState(() {}));
          Future.delayed(Duration(seconds: 10), () {
            Navigator.pop(context);
            controller.resumeCamera();
          });
        }
      }
    });
  }
}
