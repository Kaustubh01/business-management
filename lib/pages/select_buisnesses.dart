import 'package:buisness/components/add_new_buisness_dialog.dart';
import 'package:buisness/pages/dashboard.dart';
import 'package:buisness/services/buisness_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class SelectBuisnesses extends StatefulWidget {
  const SelectBuisnesses({super.key});

  @override
  State<SelectBuisnesses> createState() => _SelectBuisnessesState();
}

class _SelectBuisnessesState extends State<SelectBuisnesses> {
  List<dynamic> _businesses = [];
  bool _isLoading = true;
  String? _error;

  Future<void> _checkAuthentication() async {
    final token = await storage.read(key: 'jwt_token');
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to login if no token
    }
  }

  Future<void> _fetchBusinesses() async {
    setState(() {
      _isLoading = true;
      _error = null; // Reset error message
    });

    try {
      _businesses = await fetchBusinesses(); // Call the service function
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // Check authentication status on page load
    _fetchBusinesses(); // Fetch businesses on page load
  }

  String _truncateDescription(String? description) {
    if (description == null) return '';
    final words = description.split(' ');
    return words.length > 7 ? '${words.sublist(0, 7).join(' ')}...' : description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Select Buisness")),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/profile_page');
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Text(_error!))
                        : ListView.builder(
                            itemCount: _businesses.length,
                            itemBuilder: (context, index) {
                              final business = _businesses[index];
                              return Card(
                                color: Theme.of(context).colorScheme.primary,
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    business['name'],
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _truncateDescription(business['description']),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                    ),
                                  ),
                                  onTap: () {
                                    print(business);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(
                                          business: business, // Assuming 'id' is the key for business ID
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            "Add Buisness",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          onPressed: (){
            createNewBuisness(context);
          },
        ),
      ),
    );
  }

  void createNewBuisness(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBusinessDialog(onBusinessAdded: _fetchBusinesses);
      },
    );
    
  }
}
