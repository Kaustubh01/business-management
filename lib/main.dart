
import 'package:buisness/pages/employee_dashboard.dart';
import 'package:buisness/pages/login_page.dart';
import 'package:buisness/pages/profile_page.dart';
import 'package:buisness/pages/select_buisnesses.dart';
import 'package:buisness/pages/signup_page.dart';
import 'package:buisness/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
    return MaterialApp(
      routes: {
        '/': (context) => FutureBuilder<String?>(
              future: _getUserRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                if (!snapshot.hasData) {
                  return const LoginPage();
                }

                final role = snapshot.data;
                if (role == 'owner') {
                  return const SelectBuisnesses();
                } 
                else if (role == 'employee') {
                  return  const EmployeeHomePage();}
   
                else {
                  return const LoginPage();
                }
              },
            ),
        '/login_page':(context)=> const LoginPage(),
        '/signup_page':(context)=> const SignupPage(),
        '/select_buisnesses':(context)=>const SelectBuisnesses(),
        '/profile_page': (context)=> const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
