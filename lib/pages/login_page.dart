import 'package:buisness/components/custom/custom_input_field.dart';
import 'package:buisness/pages/employee_dashboard.dart';
import 'package:buisness/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Track loading state
  String? _errorMessage; // Track error messages

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Reset error message
      });

      try {
        final data = await login(
          _emailController.text,
          _passwordController.text,
        );

        final token = data['token'];
        final decodedToken = JwtDecoder.decode(token);
        final role = decodedToken['role'];

        // Store the token
        await storage.write(key: 'jwt_token', value: token);

        // Navigate based on the role
        if (role == 'owner') {
          Navigator.pushReplacementNamed(context, '/select_buisnesses');
        } else if (role == 'employee') {
          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EmployeeHomePage()
                      ,),);
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomInputField(
                  controller: _emailController,
                  hint: 'Email',
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (_isLoading) const CircularProgressIndicator(),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup_page'); // Navigate to register page
                  },
                  child: Text(
                    'Don\'t have an account? Register',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
