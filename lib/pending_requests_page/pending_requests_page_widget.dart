import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pending_requests_page_model.dart';
export 'pending_requests_page_model.dart';

class PendingRequestsPageWidget extends StatefulWidget {
  const PendingRequestsPageWidget({super.key});

  static String routeName = 'PendingRequestsPage';
  static String routePath = '/pendingRequestsPage';

  @override
  State<PendingRequestsPageWidget> createState() =>
      _PendingRequestsPageWidgetState();
}

class _PendingRequestsPageWidgetState extends State<PendingRequestsPageWidget> {
  late PendingRequestsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PendingRequestsPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<MasjidRequestsRow>>(
            future: MasjidRequestsTable().queryRows(
              queryFn: (q) => q,
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              List<MasjidRequestsRow>
                  pendingRequestsPanelMasjidRequestsRowList = snapshot.data!;

              return Container(
                width: double.infinity,
                height: double.infinity,
                child: custom_widgets.PendingRequestsPanel(
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
