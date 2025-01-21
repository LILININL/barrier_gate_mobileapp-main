import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'image_car_licenseplate_model.dart';
export 'image_car_licenseplate_model.dart';

class ImageCarLicenseplateWidget extends StatefulWidget {
  const ImageCarLicenseplateWidget({super.key});

  @override
  State<ImageCarLicenseplateWidget> createState() =>
      _ImageCarLicenseplateWidgetState();
}

class _ImageCarLicenseplateWidgetState
    extends State<ImageCarLicenseplateWidget> {
  late ImageCarLicenseplateModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImageCarLicenseplateModel());

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
            'assets/images/--6577.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
