import 'package:barrier_gate/Shared/SharedPreferencesControllerCenter.dart';
import 'package:barrier_gate/login/signup/preAcontroller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import '/utils/navbar_widget/navbar_widget_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notify_model.dart';

export 'notify_model.dart';

class NotifyWidget extends StatefulWidget {
  const NotifyWidget({super.key});

  @override
  State<NotifyWidget> createState() => _NotifyWidgetState();
}

class _NotifyWidgetState extends State<NotifyWidget> {
  late NotifyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final prefs = Get.put(SharedPreferencesControllerCenter(), permanent: true);
  List<RemoteMessage> notifications = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotifyModel());

    loadNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notifications.add(message);
      });

      // บันทึกการแจ้งเตือนใหม่ลง SharedPreferences
      saveNotification(message);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void saveNotification(RemoteMessage message) async {
    final prefs = Get.put(SharedPreferencesControllerCenter(), permanent: true);

    // ดึงรายการการแจ้งเตือนปัจจุบัน
    final existingNotifications = await prefs.getNotifications();

    // เพิ่มการแจ้งเตือนใหม่
    existingNotifications.add({
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'sentTime': message.sentTime?.toIso8601String(),
    });

    // บันทึกกลับไปใน SharedPreferences
    await prefs.saveNotifications(existingNotifications);
  }

  void removeNotificationFromLocal(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications') ?? [];

    notifications.removeAt(index);
    await prefs.setStringList('notifications', notifications);
  }

  void showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode, // ID ของการแจ้งเตือน (unique)
      message.notification?.title ?? 'No Title', // หัวข้อการแจ้งเตือน
      message.notification?.body ?? 'No Body', // เนื้อหาการแจ้งเตือน
      notificationDetails,
    );
  }

  void loadNotifications() async {
    final prefs = Get.put(SharedPreferencesControllerCenter(), permanent: true);

    // ดึงรายการจาก SharedPreferences
    final storedNotifications = await prefs.getNotifications();

    // แปลงเป็น `RemoteMessage`
    setState(() {
      notifications = storedNotifications.map((data) {
        return RemoteMessage(
          notification: RemoteNotification(
            title: data['title'],
            body: data['body'],
          ),
          sentTime: data['sentTime'] != null
              ? DateTime.parse(data['sentTime'])
              : null,
        );
      }).toList();
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: AlignmentDirectional(0.0, -1.0),
            image: Image.asset(
              'assets/images/bg1.png',
            ).image,
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0x7FF5F5F5),
                FlutterFlowTheme.of(context).secondaryBackground
              ],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 90.0,
                    decoration: BoxDecoration(),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(),
                          ),
                          Expanded(
                            child: wrapWithModel(
                              model: _model.headerWidgetModel,
                              updateCallback: () => safeSetState(() {}),
                              child: HeaderWidgetWidget(
                                header: 'การแจ้งเตือน',
                              ),
                            ),
                          ),
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(),
                            child: IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red), // ไอคอนลบ
                                tooltip: 'ลบทั้งหมด', // ข้อความ tooltip
                                onPressed: () async {
                                  // final confirm = await showDialog<bool>(
                                  //   context: context,
                                  //   builder: (BuildContext context) {
                                  //     return AlertDialog(
                                  //       title: Text('ยืนยันการลบทั้งหมด'),
                                  //       content: Text(
                                  //           'คุณต้องการลบการแจ้งเตือนทั้งหมดหรือไม่?'),
                                  //       actions: [
                                  //         TextButton(
                                  //           child: Text('ยกเลิก'),
                                  //           onPressed: () =>
                                  //               Navigator.of(context).pop(false),
                                  //         ),
                                  //         TextButton(
                                  //           child: Text('ยืนยัน'),
                                  //           onPressed: () =>
                                  //               Navigator.of(context).pop(true),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // );

                                  // if (confirm == true) {
                                  // ลบการแจ้งเตือนทั้งหมดใน UI
                                  setState(() {
                                    notifications.clear();
                                  });

                                  // ลบการแจ้งเตือนทั้งหมดใน SharedPreferences
                                  final prefs = Get.put(
                                      SharedPreferencesControllerCenter(),
                                      permanent: true);
                                  await prefs
                                      .clearNotifications(); // ต้องมีฟังก์ชัน clearNotifications
                                }
                                // },
                                ),
                          ),
                        ]
                            .divide(SizedBox(width: 16.0))
                            .around(SizedBox(width: 16.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 200.0),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          String dateTimeString = notification.sentTime != null
                              ? formatDateTime(notification.sentTime!)
                              : formatDateTime(
                                  DateTime.now()); // กรณี sentTime เป็น null

                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final prefs = Get.put(
                                  SharedPreferencesControllerCenter(),
                                  permanent: true);

                              // ลบการแจ้งเตือนจากหน่วยความจำ
                              setState(() {
                                notifications.removeAt(index);
                              });

                              // บันทึกสถานะใหม่กลับไปที่ SharedPreferences
                              final updatedNotifications =
                                  notifications.map((message) {
                                return {
                                  'title':
                                      message.notification?.title ?? 'No Title',
                                  'body':
                                      message.notification?.body ?? 'No Body',
                                  'sentTime':
                                      message.sentTime?.toIso8601String(),
                                };
                              }).toList();

                              await prefs
                                  .saveNotifications(updatedNotifications);

                              // นำทางไปยังหน้าอื่นเมื่อกด
                              // context.pushNamed('home_list_view');
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x19000000),
                                    offset: Offset(0.0, 0.0),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 24.0,
                                              height: 24.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent1,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  size: 12.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              notification
                                                      .notification?.title ??
                                                  'No Title',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLargeFamily,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily),
                                                      ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          dateTimeString, // คุณอาจเปลี่ยนวันที่ให้มาจาก message
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily),
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      notification.notification?.body ??
                                          'No Body',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navbarWidgetModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidgetWidget(
                    slectpage: 2,
                    hide: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
