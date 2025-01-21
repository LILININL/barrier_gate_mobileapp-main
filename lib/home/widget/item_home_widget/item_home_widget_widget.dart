import 'package:barrier_gate/function_untils/model/02BR_MB_ResidentListVillage_model.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'item_home_widget_model.dart';
export 'item_home_widget_model.dart';

class ItemHomeWidgetWidget extends StatefulWidget {
  const ItemHomeWidgetWidget({
    super.key,
    this.icon,
    required this.data,
  });

  final Widget? icon;
  final BrMbResidentListVillageModel02 data;

  @override
  State<ItemHomeWidgetWidget> createState() => _ItemHomeWidgetWidgetState();
}

class _ItemHomeWidgetWidgetState extends State<ItemHomeWidgetWidget> {
  late ItemHomeWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ItemHomeWidgetModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        image: DecorationImage(
          fit: BoxFit.contain,
          alignment: AlignmentDirectional(1.0, 1.0),
          image: Image.asset(
            'assets/images/huse.png',
          ).image,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x19000000),
            offset: Offset(
              0.0,
              0.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryBackground,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent1,
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.home_filled,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 12.0,
                        ),
                      ),
                    ),
                    Text(
                      widget.data.villageproject_display_name ?? '-',
                      // widget.data.villageproject_display_name!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
                            letterSpacing: 0.0,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyLargeFamily),
                          ),
                    ),
                  ].divide(SizedBox(width: 8.0)),
                ),
                Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
            ),
            Text(
              'บ้านเลขที่ ' + widget.data.addrpart! + ' ซอย ' + (widget.data.addr_soi ?? '-'),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    letterSpacing: 0.0,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),
            ),
          ].divide(SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}
