import 'package:buisness/components/custom/custom_input_field.dart';
import 'package:buisness/services/api_services.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isOwner = true; // Toggle between Business Owner and Employee
  bool _isLoading = false;
  String? _errorMessage;

  // Function to handle signup
  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await signup(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _phoneController.text,
          _isOwner ? 'owner' : 'employee',
        );
        // Navigate to home screen after successful registration
        Navigator.pushReplacementNamed(context, '/select_buisnesses');
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: _isOwner ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inversePrimary, backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: BorderSide(
                          color: _isOwner ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inversePrimary,
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isOwner = true;
                        });
                      },
                      child: const Text('Business Owner'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: !_isOwner ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inversePrimary, backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: BorderSide(
                          color: !_isOwner ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.inversePrimary,
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isOwner = false;
                        });
                      },
                      child: const Text('Employee'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  controller: _nameController, hint: 'Name',
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _emailController, hint: 'Email',
                  
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _phoneController,
                  hint: 'Phone No.',
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
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login_page');
                  },
                  child: Text(
                    'Already have an account? Login',
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
