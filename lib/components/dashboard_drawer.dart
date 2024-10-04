import 'package:buisness/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();

class DashboardDrawer extends StatelessWidget {
  final Map<String, dynamic> business; 
  const DashboardDrawer({super.key, required this.business});

  Future<String?> _getUserRole() async {
    final token = await storage.read(key: 'jwt_token');
    if (token == null) {
      return null;
    }
    final decodedToken = JwtDecoder.decode(token);
    
    return decodedToken['role'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.money,
              size: 48,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text("P R O F I L E"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
                ListTile(
                  title:  const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(
                          business: business,
                        ),
                      ),
                    ); 
                  },
                ),
                FutureBuilder<String?>(
                  future: _getUserRole(), 
                  builder: (context, snapshot){
                    final role = snapshot.data;
                    if(role == 'owner'){
                      return 
                        ListTile(
                          title: const Text("M Y  B U I S N E S S E S"),
                          leading: const Icon(Icons.currency_rupee),
                          onTap: () {
                              Navigator.pushNamed(context, '/select_buisnesses');
                            },
                          );
                      }
                      return 
                        ListTile(
                          title: const Text("M Y  J O B S"),
                          leading: const Icon(Icons.currency_rupee),
                          onTap: () {},
                          );

                  })
              ],
            ),
          ),
          // Logout item at the bottom
          ListTile(
            title: const Center(child: Text("Logout")),
            trailing: const Icon(Icons.logout),
            onTap: () async{
              await storage.delete(key: 'jwt_token');
              Navigator.pushNamed(context, '/login_page');
            },
          ),
        ],
      ),
    );
  }
}
