import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'image_id_card_model.dart';
export 'image_id_card_model.dart';

class ImageIdCardWidget extends StatefulWidget {
  const ImageIdCardWidget({super.key});

  @override
  State<ImageIdCardWidget> createState() => _ImageIdCardWidgetState();
}

class _ImageIdCardWidgetState extends State<ImageIdCardWidget> {
  late ImageIdCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImageIdCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/idcard.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
