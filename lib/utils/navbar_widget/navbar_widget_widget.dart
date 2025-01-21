import 'package:barrier_gate/utils/navbar_widget/navigation_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbar_widget_model.dart';
export 'navbar_widget_model.dart';

class NavbarWidgetWidget extends StatefulWidget {
  const NavbarWidgetWidget({
    Key? key,
    required this.slectpage,
    bool? hide,
  })  : this.hide = hide ?? false,
        super(key: key);

  final int slectpage;
  final bool hide;

  @override
  State<NavbarWidgetWidget> createState() => _NavbarWidgetWidgetState();
}

class _NavbarWidgetWidgetState extends State<NavbarWidgetWidget> {
  late NavigationController navigationController;
  bool isLoading = true;
  String? officerRole; // เพิ่มตัวแปรเพื่อเก็บ officerRole ในระดับ State

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationController =
          Provider.of<NavigationController>(context, listen: false);

      // ตรวจสอบว่ามี officerRole อยู่แล้วหรือไม่
      if (navigationController.officerRole == null) {
        _loadOfficerRole(); // โหลดครั้งแรกเท่านั้น
      } else {
        officerRole = navigationController.officerRole; // เก็บค่าไว้ใช้ต่อ
        isLoading = false; // ไม่ต้องเรียก setState ซ้ำ
      }
    });
  }

  Future<void> _loadOfficerRole() async {
    final role = await getOfficerRole();
    if (mounted) {
      navigationController.setOfficerRole(role);
      setState(() {
        officerRole = role;
        isLoading = false;
      });
    }
  }

  Future<String?> getOfficerRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('officer_role');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, controller, _) {
        // ตรวจสอบ officerRole ใหม่ทุกครั้งที่มีการเปลี่ยนแปลง
        final String? role = controller.officerRole;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x00FFFFFF), Color(0xE6FFFFFF)],
              stops: [0.0, 1.0],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0, 1.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 80.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16.0,
                    color: Color(0x26000000),
                    offset: Offset(0.0, 0.0),
                  )
                ],
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHomeButton(controller),
                    // ซ่อนเฉพาะเมื่อ officerRole เป็น rpp
                    if (role != 'rpp') _buildNotificationButton(controller),
                    _buildProfileButton(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeButton(NavigationController controller) {
    return _buildIconButton(
      Icons.home_filled,
      1,
      () {
        controller.setPage(1);

        // ตรวจสอบ officerRole และเปลี่ยนเส้นทาง
        final String? role =
            controller.officerRole; // ดึง role ตรงๆ ไม่ setState
        if (role == 'rpp') {
          context.pushReplacement(
            '/homeRPP',
            extra: <String, dynamic>{
              kTransitionInfoKey: TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
                duration: Duration(milliseconds: 0),
              ),
            },
          );
        } else {
          context.pushReplacement(
            '/homeListView',
            extra: <String, dynamic>{
              kTransitionInfoKey: TransitionInfo(
                hasTransition: true,
                transitionType: PageTransitionType.fade,
                duration: Duration(milliseconds: 0),
              ),
            },
          );
        }
      },
    );
  }

  Widget _buildNotificationButton(NavigationController controller) {
    return _buildIconButton(
      Icons.notifications_rounded,
      2,
      () {
        controller.setPage(2);
        context.pushReplacement(
          '/notify',
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      },
    );
  }

  Widget _buildProfileButton(NavigationController controller) {
    return _buildIconButton(
      Icons.person_2_rounded,
      3,
      () {
        controller.setPage(3);
        context.pushReplacement(
          '/meListView',
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 0),
            ),
          },
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, int page, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 100.0,
          buttonSize: 48.0,
          fillColor:
              widget.slectpage == page ? Color(0x2000613A) : Color(0x00000000),
          icon: Icon(
            icon,
            color: widget.slectpage == page
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
