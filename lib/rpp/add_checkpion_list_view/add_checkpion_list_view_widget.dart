import 'dart:async';
import 'dart:io';

import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/function_untils/controller/vehicle_visitor_controller.dart';
import 'package:barrier_gate/rpp/add_checkpion_list_view/controller/Inspcectionimage.dart';
import 'package:barrier_gate/rpp/add_checkpion_list_view/controller/InspectionImage_model.dart';
import 'package:barrier_gate/rpp/add_checkpion_list_view/controller/edit_inspcetion.dart';
import 'package:barrier_gate/rpp/checkpoint_list_r_p_p_list_view/checkpoint_delet_widget/checkpoint_delet_widget_widget.dart';
import 'package:barrier_gate/rpp/checkpoint_list_r_p_p_list_view/checkpoint_list_r_p_p_list_view_widget.dart';
import 'package:barrier_gate/utils/popup_warning/popup_warning_widget.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:barrier_gate/ehp_end_point_library/ehp_api.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/rpp/buttonsheet_cancel_save_checkpion_widget/buttonsheet_cancel_save_checkpion_widget_widget.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/popup_sucess/popup_sucess_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_checkpion_list_view_model.dart';
export 'add_checkpion_list_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddCheckpionListViewWidget extends StatefulWidget {
  final String? qrLocationId;
  final String? villageProjectId;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final String? inspectionId;
  final bool isEditMode;

  const AddCheckpionListViewWidget({
    Key? key,
    required this.qrLocationId,
    required this.villageProjectId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    this.inspectionId,
    required this.isEditMode,
  }) : super(key: key);

  @override
  State<AddCheckpionListViewWidget> createState() =>
      _AddCheckpionListViewWidgetState();
}

class _AddCheckpionListViewWidgetState
    extends State<AddCheckpionListViewWidget> {
  late AddCheckpionListViewModel _model;
  final List<File> _imageFiles = [];
  List<Uint8List> _editImages = [];
  int _currentIndex = 0;
  late PageController _pageController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? villageprojectID = '';
  String? officerID = '';
  String? inspectionId = '';
  bool _isLoading = false;

  Future<Uint8List> resizeImage(File imageFile, int width, int height) async {
    final imageBytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: width,
      targetHeight: height,
    );
    final frame = await codec.getNextFrame();
    final resizedBytes =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return resizedBytes!.buffer.asUint8List();
  }

  VillageInspectionLogsController villageInspectionLogsController =
      Get.put(VillageInspectionLogsController());

  EditSpactionDetailController editvillageInspectionLogsController =
      Get.put(EditSpactionDetailController());

  EditSpactionDetailImageController imageeditvillageInspectionLogsController =
      Get.put(EditSpactionDetailImageController());

  Future<void> _pickImageFromCamera() async {
    final overlay = Overlay.of(context);
    if (_imageFiles.length >= 4) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('คุณสามารถเพิ่มรูปภาพได้สูงสุด 4 รูป')),
      // );

      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: 40,
          right: 40,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'คุณสามารถเพิ่มรูปภาพได้สูงสุด 4 รูป',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);
      Future.delayed(Duration(seconds: 2), () {
        overlayEntry.remove();
      });

      return;
    }

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final originalFile = File(pickedFile.path);
      // บีบอัดรูปภาพ (ปรับขนาดให้เหลือ 800x800)
      final compressedBytes = await resizeImage(originalFile, 800, 800);

      // เก็บไฟล์ใหม่จากการบีบอัด
      final compressedFile = File(
          '${originalFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.png');
      await compressedFile.writeAsBytes(compressedBytes);

      setState(() {
        _imageFiles.add(compressedFile);
        _currentIndex = _imageFiles.length - 1; // ไปที่รูปภาพล่าสุด
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentIndex);
        }
      });
    }
  }

  void _deleteCurrentImage() {
    if (_imageFiles.isEmpty) return;
    setState(() {
      _imageFiles.removeAt(_currentIndex);
      if (_currentIndex >= _imageFiles.length) {
        _currentIndex =
            _imageFiles.length - 1; // ไปที่รูปสุดท้ายถ้ารูปล่าสุดถูกลบ
      }
    });
  }

  getProjectVillage() async {
    villageprojectID = (await SharedPreferencesControllerCenter()
            .getString('villageproject_id')) ??
        '';
    officerID =
        (await SharedPreferencesControllerCenter().getString('officer_id')) ??
            '';
  }

  @override
  void initState() {
    super.initState();
    getProjectVillage();
    _pageController = PageController();
    _model = createModel(context, () => AddCheckpionListViewModel());

    // ตรวจสอบว่าอยู่ในโหมดแก้ไขหรือโหมดสร้างใหม่

    if (widget.isEditMode == true) {
      setState(() {
        _isLoading = true; // เริ่มโหลด
      });

      SharedPreferencesControllerCenter()
          .getString('inspection_id')
          .then((inspectionId) async {
        if (inspectionId != null) {
          try {
            // โหลดข้อมูลหลัก
            await editvillageInspectionLogsController
                .fetchEditSpactionDetails(inspectionId)
                .then((_) {
              if (editvillageInspectionLogsController.editDetails.isNotEmpty) {
                final detail =
                    editvillageInspectionLogsController.editDetails.first;
                setState(() {
                  _model.textController0 ??=
                      TextEditingController(text: detail.location_name ?? '- ');
                  _model.textController1 ??= TextEditingController(
                      text: formatVisitorDatenotTime(
                          detail.inspection_date ?? DateTime.now()));
                  _model.textController2 ??= TextEditingController(
                      text: formatVisitorDateonlyTime(
                          detail.inspection_date ?? DateTime.now()));
                  _model.textController3 ??= TextEditingController(
                      text: detail.latitude?.toString() ?? '');
                  _model.textController4 ??= TextEditingController(
                      text: detail.longitude?.toString() ?? '');
                  _model.textController5 ??= TextEditingController(
                      text: detail.inspection_details ?? '');
                });
              }
            });

            // โหลดภาพใน Background
            await imageeditvillageInspectionLogsController
                .fetchEditSpactionDetailImages(inspectionId)
                .then((_) {
              setState(() {
                _editImages = imageeditvillageInspectionLogsController
                    .editImages
                    .map((image) => image.image_blob!)
                    .whereType<Uint8List>()
                    .toList(); // ดึงเฉพาะ image_blob ที่เป็น Uint8List
              });
            });
          } catch (error) {
            print('Error loading data: $error');
          } finally {
            setState(() {
              _isLoading = false; // เสร็จสิ้นการโหลด
            });
          }
        } else {
          setState(() {
            _isLoading = false; // กรณีไม่มี inspectionId
          });
        }
      });
    } else {
      // ค่าเริ่มต้นสำหรับโหมดสร้างใหม่

      _model.textController0 =
          TextEditingController(text: widget.locationName ?? '- ');

      _model.textController1 =
          TextEditingController(text: formatVisitorDatenotTime(DateTime.now()));
      _model.textController2 = TextEditingController(
          text: formatVisitorDateonlyTime(DateTime.now()));
      _model.textController3 =
          TextEditingController(text: widget.latitude?.toString() ?? '');
      _model.textController4 =
          TextEditingController(text: widget.longitude?.toString() ?? '');
      _model.textController5 = TextEditingController();
    }

    // กำหนด FocusNode ให้ทุกฟิลด์
    _model.textFieldFocusNode0 ??= FocusNode();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textFieldFocusNode5 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> saveLogInspection(BuildContext context) async {
    final overlay = Overlay.of(context);

    try {
      // ดึงตำแหน่งปัจจุบัน
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 2),
      );

      // ตรวจสอบระยะห่าง
      final latitudeFromText = double.tryParse(_model.textController3.text);
      final longitudeFromText = double.tryParse(_model.textController4.text);

      if (latitudeFromText == null || longitudeFromText == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('กรุณาอยู่ ใกล้ๆ พื้นที่เดียวกันกับ QR Code')),
        // );

        final overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 40,
            right: 40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'กรุณาอยู่ ใกล้ๆ พื้นที่เดียวกันกับ QR Code',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );

        overlay.insert(overlayEntry);
        Future.delayed(Duration(seconds: 2), () {
          overlayEntry.remove();
        });

        return;
      }

      final distanceInMeters = Geolocator.distanceBetween(
        latitudeFromText,
        longitudeFromText,
        position.latitude,
        position.longitude,
      );

      if (distanceInMeters >= 50) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('ตำแหน่งของคุณห่างเกิน 50 เมตรจากจุดที่ระบุ')),
        // );

        final overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 40,
            right: 40,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ตำแหน่งของคุณห่างเกิน 50 เมตรจากจุดที่ระบุ',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );

        overlay.insert(overlayEntry);
        Future.delayed(Duration(seconds: 2), () {
          overlayEntry.remove();
        });

        return;
      }

      // บันทึก VillageInspectionLogs โดยไม่ระบุ inspection_id
      final villageInspectionLogs = VillageInspectionLogs(
        null, // ไม่ระบุ inspection_id
        int.tryParse(officerID!), // officerID
        int.tryParse(widget.qrLocationId!), // qr_location_id
        null, // officer_id
        _model.textController5.text, // inspection_details
        DateTime.now(), // uploaded_at
      );

      // บันทึก Inspection Logs และจัดการรูปภาพใน then block
      await VillageInspectionLogsController.saveVillageInspectionLogs(
              villageInspectionLogs)
          .then((savedLogs) async {
        await villageInspectionLogsController.getVillageInspectionLogs();
        final ins_id = villageInspectionLogsController
            .villageInspectionLogsList.first.inspection_id!;
        if (savedLogs == null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('ไม่สามารถบันทึก จุดตรวจได้ Logs ได้')),
          // );

          final overlayEntry = OverlayEntry(
            builder: (context) => Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 40,
              right: 40,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'ไม่สามารถบันทึก จุดตรวจได้',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );

          overlay.insert(overlayEntry);
          Future.delayed(Duration(seconds: 2), () {
            overlayEntry.remove();
          });
          return;
        }

        // บันทึกรูปภาพทั้งหมด
        final imageController = Get.put(VillageInspectionImageController());

        bool allSavedSuccessfully = true;

        for (var imageFile in _imageFiles) {
          final bytes = await imageFile.readAsBytes();

          final villageInspectionImage = VillageInspectionImage(
            null, // image_id
            ins_id, // inspection_id ที่ได้จาก Backend
            bytes, // ข้อมูลภาพ
            DateTime.now(), // เวลาที่บันทึก
          );

          final imageSaveResult = await imageController
              .saveVillageInspectionImage(villageInspectionImage);

          if (!imageSaveResult) {
            allSavedSuccessfully = false;
            break;
          }
        }

        // แสดงผลลัพธ์
        if (allSavedSuccessfully) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('บันทึกข้อมูลและรูปภาพสำเร็จ')),
          // );

          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(const Duration(seconds: 1), () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                  if (allSavedSuccessfully) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CheckpointListRPPListViewWidget()),
                    );
                  }
                }
              });
              return PopupSucessWidget();
            },
          );
        } else {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกภาพบางส่วน')),
          // );

          final overlayEntry = OverlayEntry(
            builder: (context) => Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 40,
              right: 40,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'เกิดข้อผิดพลาดในการบันทึกภาพบางส่วน',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );

          overlay.insert(overlayEntry);
          Future.delayed(Duration(seconds: 2), () {
            overlayEntry.remove();
          });
        }
      }).catchError((e) {
        // จัดการข้อผิดพลาดระหว่างการบันทึก Logs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
        );
      });
    } catch (e) {
      // จัดการข้อผิดพลาดระหว่างกระบวนการทั้งหมด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
      print('Error saving data and images: $e');
    }
  }

// ฟังก์ชันลบข้อมูลและรูปภาพ
  Future<bool> deleteInspectionAndImages(String inspectionId) async {
    final inspectionController = Get.put(VillageInspectionLogsController());
    bool allDeletedSuccessfully = true;

    try {
      final response = await serviceLocator<EHPApi>().getRestAPI(
        VillageInspectionImage.newInstance(),
        '?inspection_id=$inspectionId',
      );

      if (response.isNotEmpty) {
        for (var image in response) {
          final villageInspectionImage = VillageInspectionImage.newInstance();
          if (image is VillageInspectionImage) {
            villageInspectionImage.image_id = image.image_id;
          }

          final imageDeleteResult = await VillageInspectionImageController
              .deleteVillageInspectionImage(villageInspectionImage);

          if (!imageDeleteResult) {
            allDeletedSuccessfully = false;
            break;
          }
        }
      }

      final inspectionDeleteResult =
          await inspectionController.deleteVillageInspectionLogs(
        VillageInspectionLogs(
            int.tryParse(inspectionId), null, null, null, null, null),
      );

      return allDeletedSuccessfully && inspectionDeleteResult;
    } catch (e) {
      print('เกิดข้อผิดพลาดระหว่างการลบ: $e');
      return false;
    }
  }

  // Future<void> deleteSingleInspection(String inspectionId) async {
  //   final inspectionController = Get.put(VillageInspectionLogsController());

  //   final result = await inspectionController.deleteVillageInspectionLogs(
  //     VillageInspectionLogs(
  //         int.tryParse(inspectionId), null, null, null, null, null),
  //   );

  //   if (result) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('ลบจุดตรวจสำเร็จ')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('ลบจุดตรวจไม่สำเร็จ')),
  //     );
  //   }
  // }

  // Future<void> deleteImagesByInspectionId(String inspectionId) async {
  //   bool allDeletedSuccessfully = true;

  //   try {
  //     // ดึงรูปภาพทั้งหมดที่เกี่ยวข้อง
  //     final response = await serviceLocator<EHPApi>().getRestAPI(
  //       VillageInspectionImage.newInstance(),
  //       '?inspection_id=$inspectionId',
  //     );

  //     if (response.isEmpty) {
  //       print('ไม่พบรูปภาพที่เกี่ยวข้องกับ inspection_id: $inspectionId');
  //       return;
  //     }

  //     // วนลูปลบทีละรูป
  //     for (var image in response) {
  //       final villageInspectionImage = VillageInspectionImage.newInstance();

  //       if (image is VillageInspectionImage) {
  //         villageInspectionImage.image_id = image.image_id;
  //       }

  //       final imageDeleteResult =
  //           await VillageInspectionImageController.deleteVillageInspectionImage(
  //               villageInspectionImage);

  //       if (!imageDeleteResult) {
  //         allDeletedSuccessfully = false;
  //         break;
  //       }
  //     }

  //     if (allDeletedSuccessfully) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('ลบรูปภาพทั้งหมดสำเร็จ')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('เกิดข้อผิดพลาดในการลบรูปภาพบางส่วน')),
  //       );
  //     }
  //   } catch (e) {
  //     print('เกิดข้อผิดพลาดระหว่างการลบรูปภาพ: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
  //     );
  //   }
  // }

  @override
  void dispose() {
    _model.dispose();
    // Navigator.of(context).popUntil((route) => route.isFirst);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFBBF4F6),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: AlignmentDirectional(0.0, -1.0),
            image: Image.asset(
              'assets/images/bg4_1.png',
            ).image,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66FFFFFF), Color(0x00FFFFFF)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: 90.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).secondaryBackground,
                        Color(0x00FFFFFF)
                      ],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(0.0, -1.0),
                      end: AlignmentDirectional(0, 1.0),
                    ),
                  ),
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
                              color: FlutterFlowTheme.of(context).primary,
                              size: 20.0,
                            ),
                            onPressed: () async {
                              if (!widget.isEditMode) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  barrierColor: const Color(0x3F000000),
                                  isDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child:
                                          ButtonsheetCancelSaveCheckpionWidgetWidget(),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              } else {
                                context
                                    .pushNamed('CheckpointList_RPP_list_view');
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: wrapWithModel(
                            model: _model.headerWidgetModel,
                            updateCallback: () => safeSetState(() {}),
                            child: HeaderWidgetWidget(
                              header: widget.isEditMode
                                  ? 'ข้อมูลจุดตรวจ'
                                  : 'บันทึกข้อมูลจุดตรวจ',
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.isEditMode, //
                          child: Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(),
                            child: FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 20.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: FlutterFlowTheme.of(context).error,
                                  size: 30.0,
                                ),
                                onPressed: () async {
                                  if (widget.isEditMode) {
                                    final confirm = await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: EdgeInsets.all(10),
                                          child: CheckpointDeletWidgetWidget(),
                                        );
                                      },
                                    );

                                    if (confirm == true) {
                                      var inspection =
                                          (await SharedPreferencesControllerCenter()
                                                  .getString(
                                                      'inspection_id')) ??
                                              '';

                                      final deleteSuccess =
                                          await deleteInspectionAndImages(
                                              inspection);

                                      if (deleteSuccess) {
                                        BuildContext? dialogContext;

                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              if (Navigator.of(context)
                                                  .canPop()) {
                                                Navigator.of(context).pop();
                                              }
                                            });
                                            return PopupSucessWidget();
                                          },
                                        );

                                        context.pushReplacementNamed(
                                            'CheckpointList_RPP_list_view');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'เกิดข้อผิดพลาดในการลบข้อมูล')),
                                        );
                                      }
                                    }
                                  } else {
                                    context.pushReplacementNamed(
                                        'CheckpointList_RPP_list_view');
                                  }
                                }),
                          ),
                        ),
                      ]
                          .divide(SizedBox(width: 16.0))
                          .around(SizedBox(width: 16.0)),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8.0,
                            color: Color(0x33000000),
                            offset: Offset(
                              0.0,
                              2.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      _model.textController0.text ?? '- ',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: _isLoading
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: double.infinity,
                                              height: 250.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              // แสดงรูปภาพใน PageView
                                              if (_editImages.isNotEmpty ||
                                                  _imageFiles.isNotEmpty)
                                                PageView.builder(
                                                  controller: _pageController,
                                                  itemCount:
                                                      _editImages.isNotEmpty
                                                          ? _editImages.length
                                                          : _imageFiles.length,
                                                  onPageChanged: (index) {
                                                    setState(() {
                                                      _currentIndex = index;
                                                    });
                                                  },
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (_editImages
                                                        .isNotEmpty) {
                                                      return Image.memory(
                                                        _editImages[index],
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      );
                                                    } else {
                                                      return Image.file(
                                                        _imageFiles[index],
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      );
                                                    }
                                                  },
                                                )
                                              else if (!widget.isEditMode)
                                                // ปุ่มถ่ายรูปตรงกลางจอในโหมดสร้างใหม่
                                                GestureDetector(
                                                  onTap: _pickImageFromCamera,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.add_a_photo,
                                                          color: Colors.grey,
                                                          size: 48.0,
                                                        ),
                                                        SizedBox(height: 8.0),
                                                        Text(
                                                          'เพิ่มรูปภาพ',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              else
                                                // ข้อความ "ไม่มีรูปภาพ" สำหรับโหมดแก้ไข
                                                Center(
                                                  child: Text(
                                                    'ไม่มีรูปภาพ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              // ปุ่มลบรูป อยู่มุมขวาบน (แสดงเมื่อมีรูปภาพ)
                                              if (!widget.isEditMode &&
                                                  (_editImages.isNotEmpty ||
                                                      _imageFiles.isNotEmpty))
                                                Positioned(
                                                  top: 8.0,
                                                  right: 8.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (_editImages
                                                            .isNotEmpty) {
                                                          _editImages.removeAt(
                                                              _currentIndex);

                                                          // ตรวจสอบและปรับ _currentIndex
                                                          if (_currentIndex >=
                                                              _editImages
                                                                  .length) {
                                                            _currentIndex = _editImages
                                                                    .isNotEmpty
                                                                ? _editImages
                                                                        .length -
                                                                    1
                                                                : 0; // รีเซ็ตเมื่อไม่มีรูปเหลือ
                                                          }
                                                        } else if (_imageFiles
                                                            .isNotEmpty) {
                                                          _imageFiles.removeAt(
                                                              _currentIndex);

                                                          // ตรวจสอบและปรับ _currentIndex
                                                          if (_currentIndex >=
                                                              _imageFiles
                                                                  .length) {
                                                            _currentIndex = _imageFiles
                                                                    .isNotEmpty
                                                                ? _imageFiles
                                                                        .length -
                                                                    1
                                                                : 0; // รีเซ็ตเมื่อไม่มีรูปเหลือ
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 32.0,
                                                      height: 32.0,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              // ปุ่มเพิ่มรูป อยู่มุมล่างซ้าย (แสดงเมื่อมีรูปภาพ)
                                              if (!widget.isEditMode &&
                                                  (_editImages.isNotEmpty ||
                                                      _imageFiles.isNotEmpty))
                                                Positioned(
                                                  bottom: 16.0,
                                                  left: 16.0,
                                                  child: GestureDetector(
                                                    onTap: _pickImageFromCamera,
                                                    child: Container(
                                                      width: 48.0,
                                                      height: 48.0,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black87,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 6.0,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.white,
                                                        size: 24.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              // แสดงเลขหน้าของรูป
                                              if (_editImages.isNotEmpty ||
                                                  _imageFiles.isNotEmpty)
                                                Positioned(
                                                  bottom: 16.0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 6.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Text(
                                                        '${_currentIndex + 1}/${_editImages.isNotEmpty ? _editImages.length : 4}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              // if (_editImages.isNotEmpty ||
                                              //     _imageFiles.isNotEmpty)
                                              //   Positioned(
                                              //     bottom: 0.0,
                                              //     left: 355,
                                              //     right: 0,
                                              //     child: Center(
                                              //       child: Container(
                                              //         padding:
                                              //             EdgeInsets.symmetric(
                                              //           horizontal: 12.0,
                                              //           vertical: 6.0,
                                              //         ),
                                              //         decoration: BoxDecoration(
                                              //           color: Colors.black
                                              //               .withOpacity(0.5),
                                              //           borderRadius:
                                              //               BorderRadius
                                              //                   .circular(8.0),
                                              //         ),
                                              //         child: Text(
                                              //           '${_currentIndex + 1}',
                                              //           style: TextStyle(
                                              //             color: Colors.white,
                                              //             fontSize: 16.0,
                                              //             fontWeight:
                                              //                 FontWeight.bold,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                            ],
                                          ),
                                  ),
                                  MasonryGridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                    ),
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 24.0,
                                    itemCount: 2,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return [
                                        () => Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _model.textController1,
                                                    focusNode: _model
                                                        .textFieldFocusNode1,
                                                    readOnly: true,
                                                    //widget.isEditMode
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'วันที่',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                                color: widget
                                                                        .isEditMode
                                                                    ? Colors
                                                                        .grey // สีของ Label เมื่อ isEditMode เป็น true
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                              ),
                                                      alignLabelWithHint: false,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                        color: Colors
                                                            .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                        // : FlutterFlowTheme
                                                        //         .of(context)
                                                        //     .primaryText,
                                                        ),
                                                    validator: _model
                                                        .textController1Validator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _model.textController2,
                                                    focusNode: _model
                                                        .textFieldFocusNode2,
                                                    readOnly: true,
                                                    //widget.isEditMode
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'เวลา',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                                color: widget
                                                                        .isEditMode
                                                                    ? Colors
                                                                        .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                              ),
                                                      alignLabelWithHint: false,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                        color: Colors
                                                            .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                        // : FlutterFlowTheme
                                                        //         .of(context)
                                                        //     .primaryText,
                                                        ),
                                                    validator: _model
                                                        .textController2Validator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                        () => Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _model.textController3,
                                                    focusNode: _model
                                                        .textFieldFocusNode3,
                                                    readOnly: true,
                                                    //widget.isEditMode
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: 'พิกัด',
                                                      labelStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .labelLargeFamily),
                                                                color: widget
                                                                        .isEditMode
                                                                    ? Colors
                                                                        .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                              ),
                                                      alignLabelWithHint: false,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                        color: Colors
                                                            .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                        // : FlutterFlowTheme
                                                        //         .of(context)
                                                        //     .primaryText,
                                                        ),
                                                    validator: _model
                                                        .textController3Validator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        _model.textController4,
                                                    focusNode: _model
                                                        .textFieldFocusNode4,
                                                    readOnly: true,
                                                    //widget.isEditMode
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily),
                                                          color: Colors
                                                              .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                          // : FlutterFlowTheme.of(
                                                          //         context)
                                                          //     .primaryText,
                                                          ),
                                                      alignLabelWithHint: false,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                    ),
                                                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily),
                                                        color: Colors
                                                            .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                        // : FlutterFlowTheme
                                                        //         .of(context)
                                                        //     .primaryText,
                                                        ),
                                                    validator: _model
                                                        .textController4Validator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                      ][index]();
                                    },
                                  ),
                                  TextFormField(
                                    controller: _model.textController5,
                                    focusNode: _model.textFieldFocusNode5,
                                    readOnly: widget.isEditMode,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'รายละเอียด',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelLargeFamily,
                                            color: widget.isEditMode
                                                ? Colors
                                                    .grey // สีข้อความเมื่อ isEditMode เป็น true
                                                : FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .labelLargeFamily),
                                            lineHeight: 1.0,
                                          ),
                                      alignLabelWithHint: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 16.0, 16.0, 16.0),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLargeFamily),
                                          color: widget.isEditMode
                                              ? Colors
                                                  .grey // สีข้อความเมื่อ isEditMode เป็น true
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    validator: _model.textController5Validator
                                        .asValidator(context),
                                  ),
                                ].divide(SizedBox(height: 24.0)),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Visibility(
                                visible: !widget.isEditMode, //
                                child: ElevatedButton(
                                  onPressed: (widget.isEditMode)
                                      ? null // ปิดการใช้งานปุ่มเมื่อ isEditMode เป็น true
                                      : () async {
                                          if (_imageFiles.isEmpty ||
                                              _imageFiles.length < 1) {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                Future.delayed(
                                                    Duration(seconds: 2), () {
                                                  if (Navigator.of(context)
                                                      .canPop()) {
                                                    Navigator.of(context).pop();
                                                  }
                                                });
                                                return PopupWarningWidget();
                                              },
                                            );
                                            return;
                                          }
                                          await saveLogInspection(
                                              context); // เรียกฟังก์ชันเมื่อปุ่มเปิดใช้งาน
                                        },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        Size(double.infinity, 56.0), // ขนาดปุ่ม
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24.0), // Padding ปุ่ม
                                    backgroundColor: (widget.isEditMode)
                                        ? Colors.grey // สีปุ่มเมื่อปิดใช้งาน
                                        : FlutterFlowTheme.of(context)
                                            .primary, // สีปุ่มเมื่อเปิดใช้งาน
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          100.0), // ขอบปุ่มโค้งมน
                                    ),
                                  ),
                                  child: Text(
                                    (widget.isEditMode)
                                        ? 'ตกลง' // ข้อความเมื่อปุ่มปิดใช้งาน
                                        : 'ตกลง', // ข้อความเมื่อปุ่มเปิดใช้งาน
                                    style: TextStyle(
                                      fontSize: 16.0, // ขนาดตัวอักษร
                                      fontWeight:
                                          FontWeight.w600, // น้ำหนักตัวอักษร
                                      color: (widget.isEditMode)
                                          ? Colors
                                              .white70 // สีข้อความเมื่อปิดใช้งาน
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground, // สีข้อความเมื่อเปิดใช้งาน
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showOverlayNotification(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) async {
    final completer = Completer<void>();
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            //
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
      completer.complete();
    });

    return completer.future;
  }

  String formatVisitorDatenotTime(DateTime? dateTime, {String prefix = ''}) {
    if (dateTime == null) return '$prefix -';

    // เพิ่ม 543 ปีและกำหนดรูปแบบการแสดงผล
    DateTime buddhistDate =
        DateTime(dateTime.year + 543, dateTime.month, dateTime.day);

    // กำหนดฟอร์แมตของวันที่เป็นภาษาไทย
    final formattedDateTime =
        DateFormat('d MMMM y', 'th_TH').format(buddhistDate);

    return '$prefix$formattedDateTime';
  }

  String formatVisitorDateonlyTime(DateTime? dateTime, {String prefix = ''}) {
    if (dateTime == null) return '$prefix -';
    final formattedDateTime = dateTimeFormat(
        "HH:mm",
        DateTime(dateTime.year + 543, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second));
    return '$prefix$formattedDateTime';
  }

  DateTime? convertToBuddhistYear(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year + 543, date.month, date.day, date.hour,
        date.minute, date.second);
  }
}
