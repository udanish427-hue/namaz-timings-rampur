// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class PendingRequestsPanel extends StatefulWidget {
  const PendingRequestsPanel({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _PendingRequestsPanelState createState() => _PendingRequestsPanelState();
}

class _PendingRequestsPanelState extends State<PendingRequestsPanel> {
  List<dynamic> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final data = await SupaFlow.client
          .from('masjid_requests')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _requests = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching requests: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _approveRequest(dynamic request) async {
    try {
      await SupaFlow.client.from('mosques').insert({
        'name': request['masjid_name'],
        'address': request['address'],
        'phone_number': request['phone'],
        'mutawalli_name': request['name'],
        'fajr': '--:--',
        'dhuhr': '--:--',
        'asr': '--:--',
        'maghrib': '--:--',
        'isha': '--:--',
        'jummah': '--:--',
      });

      await SupaFlow.client
          .from('masjid_requests')
          .delete()
          .eq('id', request['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Masjid Approved & Added!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      _fetchRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectRequest(dynamic request) async {
    try {
      await SupaFlow.client
          .from('masjid_requests')
          .delete()
          .eq('id', request['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request Rejected!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      _fetchRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.yellow),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PENDING REGISTRATIONS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _requests.isEmpty
                ? const Center(
                    child: Text(
                      'Koi pending request nahi hai.',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final req = _requests[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.yellow, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req['masjid_name'] ?? 'Unknown Masjid',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${req['name'] ?? ''}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Phone: ${req['phone'] ?? ''}',
                                style: const TextStyle(color: Colors.white70)),
                            Text('Address: ${req['address'] ?? ''}',
                                style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _rejectRequest(req),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('REJECT'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _approveRequest(req),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('APPROVE'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
