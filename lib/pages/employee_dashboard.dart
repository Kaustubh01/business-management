import 'package:buisness/services/api_services.dart';
import 'package:flutter/material.dart'; // Import the services file

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _businesses = [];
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoadingBusinesses = true;
  bool _isLoadingRequests = true;
  String? _business_error;
  String? _request_error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchBusinesses();
    _fetchPendingRequests();
  }

  Future<void> _fetchBusinesses() async {
    setState(() {
      _isLoadingBusinesses = true;
    });

    try {
      final businesses = await fetchEmployeeBusinesses();
      setState(() {
        _businesses = businesses;
        _isLoadingBusinesses = false;
      });
    } catch (e) {
      setState(() {
        _business_error = 'Error: ${e.toString()}';
        _isLoadingBusinesses = false;
      });
    }
  }

  Future<void> _fetchPendingRequests() async {
    setState(() {
      _isLoadingRequests = true;
    });

    try {
      final requests = await fetchPendingRequests();
      setState(() {
        _pendingRequests = requests;
        _isLoadingRequests = false;
      });
    } catch (e) {
      setState(() {
        _request_error = 'Error: ${e.toString()}';
        _isLoadingRequests = false;
      });
    }
  }

  Future<void> _acceptRequest(String businessId) async {
    try {
      await acceptRequest(businessId);
      _fetchPendingRequests();
      _fetchBusinesses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _rejectRequest(String businessId) async {
    try {
      await rejectRequest(businessId);
      _fetchPendingRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Businesses'),
            Tab(text: 'Pending Requests'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
              Navigator.pushNamed(context, '/login_page');
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBusinessesTab(),
          _buildPendingRequestsTab(),
        ],
      ),
    );
  }

  Widget _buildBusinessesTab() {
    return _isLoadingBusinesses
        ? const Center(child: CircularProgressIndicator())
        : _business_error != null
            ? Center(child: Text(_business_error!))
            : ListView.builder(
                itemCount: _businesses.length,
                itemBuilder: (context, index) {
                  final business = _businesses[index];
                  final name = business['name'] ?? 'No Name';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(name),
                    ),
                  );
                },
              );
  }

  Widget _buildPendingRequestsTab() {
    return _isLoadingRequests
        ? const Center(child: CircularProgressIndicator())
        : _request_error != null
            ? Center(child: Text(_request_error!))
            : ListView.builder(
                itemCount: _pendingRequests.length,
                itemBuilder: (context, index) {
                  final request = _pendingRequests[index];
                  final businessName = request['businessName'] ?? 'No Business Name';
                  final businessId = request['businessId'];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('Invitation from $businessName'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              _acceptRequest(businessId);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _rejectRequest(businessId);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
