import 'dart:convert';

import 'package:barrier_gate/rpp/check_infomation_externalvehicleregistration/Controller/auto_plate_controller.dart';
import 'package:barrier_gate/rpp/visitorcarregistration/controller/villageproject_detail_controller.dart';
import 'package:get/get.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/popup_loading/popup_loading_widget.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'externalvehicleregistration_model.dart';
export 'externalvehicleregistration_model.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class ExternalvehicleregistrationWidget extends StatefulWidget {
  const ExternalvehicleregistrationWidget({super.key});

  @override
  State<ExternalvehicleregistrationWidget> createState() =>
      _ExternalvehicleregistrationWidgetState();
}

class _ExternalvehicleregistrationWidgetState
    extends State<ExternalvehicleregistrationWidget>
    with TickerProviderStateMixin {
  late ExternalvehicleregistrationModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};
  IDCardController idCardController = Get.put(IDCardController());
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String name = 'ไม่พบชื่อ';
  String idNumber = 'ไม่พบหมายเลขบัตรประชาชน';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExternalvehicleregistrationModel());
    initializeCamera();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    animationsMap.addAll({
      'containerOnPageLoadAnimation1': AnimationInfo(
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
      'containerOnPageLoadAnimation2': AnimationInfo(
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

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเปิดกล้องได้: $e')),
      );
    }
  }

  Future<Map<String, String>> readIDCard(File imageFile) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(imageFile);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    List<String> allLines = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        allLines.add(line.text);
        print('Line: ${line.text}');
      }
    }
    String extractIDNumber(List<String> lines) {
      for (String line in lines) {
        if (RegExp(r'\d{1}\s\d{4}\s\d{5}\s\d{3}').hasMatch(line)) {
          return RegExp(r'\d{1}\s\d{4}\s\d{5}\s\d{3}')
              .firstMatch(line)!
              .group(0)!
              .trim();
        }
      }
      return 'ไม่พบเลขบัตรประชาชน';
    }

    String extractName(List<String> lines) {
      String firstName = '';
      String lastName = '';

      for (String line in lines) {
        if (RegExp(r'(Mr\.|Mrs\.|Ms\.|Miss|Name)').hasMatch(line)) {
          firstName = line
              .replaceAll(
                  RegExp(r'(Name|Mr\.|Mrs\.|Ms\.|Miss|:)',
                      caseSensitive: false),
                  '')
              .trim();
        }

        if (line.toLowerCase().contains("last name")) {
          lastName = line
              .replaceAll(RegExp(r'(Last name|:)', caseSensitive: false), '')
              .trim();
        }
      }

      return firstName.isNotEmpty && lastName.isNotEmpty
          ? '$firstName $lastName'
          : firstName.isNotEmpty
              ? firstName
              : lastName.isNotEmpty
                  ? lastName
                  : 'ไม่พบชื่อ - นามสกุล';
    }

    String name = extractName(allLines);
    String idNumber = extractIDNumber(allLines);

    print('Extracted Name: $name');
    print('Extracted ID Number: $idNumber');

    textRecognizer.close();

    return {'name': name, 'idNumber': idNumber};
  }

  Future<void> captureAndReadText() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera is not ready');
      return;
    }

    try {
      final tempDir = Directory.systemTemp;
      final imagePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _cameraController!
          .takePicture()
          .then((value) => value.saveTo(imagePath));
      print('Image captured and saved to $imagePath');

      final result = await readIDCard(File(imagePath));

      print('ชื่อ: ${result['name']}');
      print('เลขบัตรประชาชน: ${result['idNumber']}');

      // ส่งข้อมูลไปยัง Controller
      final idCardController = Get.find<IDCardController>();
      idCardController.updateIDCardInfo(
        result['name'] ?? 'ไม่พบชื่อ - นามสกุล',
        result['idNumber'] ?? 'ไม่พบเลขบัตรประชาชน',
      );
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _model.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> captureAndSendImage() async {
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        // ถ่ายรูป
        final image = await _cameraController!.takePicture();

        // อ่านไฟล์ภาพและแปลงเป็น Base64
        final bytes = await image.readAsBytes();
        String base64Image = base64Encode(bytes);

        // เรียก API ที่สร้างไว้ใน PlateController
        PlateController plateController = Get.find();
        plateController.plateImage.value = base64Image;
        await plateController.sendPlateImageWithToken();
      } else {
        print("Camera is not initialized.");
      }
    } catch (e) {
      print("Error capturing or sending image: $e");
    }
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: 59.0,
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
                          height: 10.0,
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
                        // Expanded(
                        //   child: Container(
                        //     width: double.infinity,
                        //     height: 10.0,
                        //     decoration: BoxDecoration(),
                        //     child: Align(
                        //       alignment: AlignmentDirectional(0.0, 0.0),
                        //       child: Text(
                        //         'เพิ่มข้อมูลรถยนต์ผู้มาติดต่อ',
                        //         style: FlutterFlowTheme.of(context)
                        //             .titleMedium
                        //             .override(
                        //               fontFamily: FlutterFlowTheme.of(context)
                        //                   .titleMediumFamily,
                        //               color: FlutterFlowTheme.of(context)
                        //                   .secondaryBackground,
                        //               letterSpacing: 0.0,
                        //               fontWeight: FontWeight.w500,
                        //               useGoogleFonts: GoogleFonts.asMap()
                        //                   .containsKey(
                        //                       FlutterFlowTheme.of(context)
                        //                           .titleMediumFamily),
                        //             ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          width: 48.0,
                          height: 20.0,
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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _model.pageViewController ??=
                      PageController(initialPage: 0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    'กรุณาถ่ายรูปบัตรประชาชนของผู้มาติดต่อให้อยู่ในกรอบที่กำหนด',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w300,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 600.0,
                                    height: 300.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: _cameraController != null &&
                                              _cameraController!
                                                  .value.isInitialized
                                          ? AspectRatio(
                                              aspectRatio: _cameraController!
                                                  .value.aspectRatio,
                                              child: CameraPreview(
                                                  _cameraController!),
                                            )
                                          : Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 32.0),
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
                                      child: FlutterFlowIconButton(
                                        borderColor: Colors.transparent,
                                        borderRadius: 100.0,
                                        buttonSize: 62.0,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          await captureAndReadText();

                                          _model.pageViewController
                                              ?.animateToPage(
                                            1,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        // Fullscreen Camera Preview
                        // Positioned.fill(
                        //   child: widget.cameraController.value.isInitialized
                        //       ? CameraPreview(widget.cameraController)
                        //       : Center(
                        //           child: CircularProgressIndicator(),
                        //         ),
                        // ),
                        // Overlay UI
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top Overlay Text
                            Container(
                              color: Colors.black.withOpacity(0.6),
                              padding: const EdgeInsets.only(bottom: 0.0),
                              width: double.infinity,
                              child: Text(
                                'กรุณาถ่ายรูปป้ายทะเบียนรถของผู้มาติดต่อให้อยู่ในกรอบที่กำหนด',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            // Spacer to add space between elements
                            // Middle Container with License Plate Frame
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 500.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                child: Center(
                                  child: Center(
                                    child: Container(
                                      width: 500.0,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: _cameraController != null &&
                                                _cameraController!
                                                    .value.isInitialized
                                            ? AspectRatio(
                                                aspectRatio: _cameraController!
                                                    .value.aspectRatio,
                                                child: CameraPreview(
                                                    _cameraController!),
                                              )
                                            : Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 32.0),
                            child: Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 32.0,
                                ),
                                onPressed: () async {
                                  try {
                                    await captureAndSendImage();
                                    await SystemChrome
                                        .setPreferredOrientations([
                                      DeviceOrientation.portraitUp,
                                      DeviceOrientation.portraitDown,
                                    ]);
                                    // showModalBottomSheet(
                                    //   isScrollControlled: true,
                                    //   backgroundColor: Colors.transparent,
                                    //   barrierColor: Color(0x3F000000),
                                    //   isDismissible: false,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return Padding(
                                    //       padding:
                                    //           MediaQuery.viewInsetsOf(context),
                                    //       child: PopupLoadingWidget(),
                                    //     );
                                    //   },
                                    // );

                                    // await Future.delayed(
                                    //     const Duration(seconds: 2));

                                    // Navigate to next page
                                    context.pushNamed(
                                      'check_infomation_externalvehicleregistration',
                                      extra: <String, dynamic>{
                                        kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                          duration: Duration(milliseconds: 0),
                                        ),
                                      },
                                    );
                                  } catch (e) {
                                    print("Error capturing image: $e");
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ].divide(SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}
