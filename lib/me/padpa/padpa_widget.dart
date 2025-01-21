import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/utils/header_widget/header_widget_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'padpa_model.dart';
export 'padpa_model.dart';

class PadpaWidget extends StatefulWidget {
  const PadpaWidget({super.key});

  @override
  State<PadpaWidget> createState() => _PadpaWidgetState();
}

class _PadpaWidgetState extends State<PadpaWidget> {
  late PadpaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PadpaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
      backgroundColor: Color(0xFFBBF4F6),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            alignment: AlignmentDirectional(0.0, -1.0),
            image: Image.asset(
              'assets/images/bgcpw.png',
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
                            context.safePop();
                          },
                        ),
                      ),
                      Expanded(
                        child: wrapWithModel(
                          model: _model.headerWidgetModel,
                          updateCallback: () => safeSetState(() {}),
                          child: HeaderWidgetWidget(
                            header: 'นโยบายความเป็นส่วนตัว',
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
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Icon(
                                    Icons.verified_user_sharp,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 60.0,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'การขอความยินยอมในการรวบรวมข้อมูลส่วนบุคคล',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                    ),
                                    Text(
                                      'เพื่อให้สอดคล้องกับกฎหมายคุ้มครองข้อมูลส่วนบุคคล และเพื่อให้เราสามารถให้บริการที่ดีที่สุดแก่ท่านได้ บริษัท [ชื่อบริษัท] มีความจำเป็นต้องเก็บรวบรวมข้อมูลส่วนบุคคลของท่าน เราขอความยินยอมจากท่านในการเก็บรวบรวมข้อมูลส่วนบุคคลเพื่อวัตถุประสงค์ดังต่อไปนี้:\nเพื่อการให้บริการและการสนับสนุนต่างๆ ที่เกี่ยวข้อง\nเพื่อพัฒนาผลิตภัณฑ์และบริการของเรา\nเพื่อวิเคราะห์และประเมินการใช้บริการของท่าน\nเพื่อจัดส่งข้อมูลข่าวสาร ข้อเสนอพิเศษ และโปรโมชันที่อาจตรงกับความสนใจของท่าน',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                    Text(
                                      'ข้อมูลส่วนบุคคลที่เราจะเก็บรวบรวมได้แก่:\nชื่อ-นามสกุล\nข้อมูลติดต่อ เช่น อีเมล หมายเลขโทรศัพท์\nข้อมูลการใช้งานเว็บไซต์หรือแอปพลิเคชัน\nโปรดอ่านและพิจารณานโยบายความเป็นส่วนตัวของเราที่ [ลิงก์นโยบายความเป็นส่วนตัว] เพื่อดูรายละเอียดเพิ่มเติมเกี่ยวกับการเก็บรักษาและการใช้ข้อมูลส่วนบุคคลของท่าน',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                ),
                                Text(
                                  'หากท่านยินยอมให้เรารวบรวมและใช้ข้อมูลส่วนบุคคลของท่าน กรุณาคลิกที่ปุ่ม \"ยินยอม\" ด้านล่าง หากท่านไม่ยินยอม กรุณากด \"ปฏิเสธ\"',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ].divide(SizedBox(height: 24.0)),
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
    );
  }
}
