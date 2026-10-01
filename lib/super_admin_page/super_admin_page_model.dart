import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'super_admin_page_widget.dart' show SuperAdminPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SuperAdminPageModel extends FlutterFlowModel<SuperAdminPageWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadDataP2v = false;
  FFUploadedFile uploadedLocalFile_uploadDataP2v =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataP2v = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
