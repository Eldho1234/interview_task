import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_constants.dart';
import 'package:interview_task/core/app/app_routes.dart';
import 'package:interview_task/feature/auth/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showPass = true;

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    bool success = await auth.login(email, password);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          success ? 'Login Successful' : 'Invalid credentials',
          style: const TextStyle(color: Colors.black),
        )));
    if (success) {
      final isAdmin = auth.user?.email == AppConstants.adminEmail;
      Navigator.pushReplacementNamed(
        context,
        isAdmin ? '/adminDash' : '/home',
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 600;
              final cardWidth = isWideScreen ? 500.0 : double.infinity;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? 40 : 20,
                    vertical: 40,
                  ),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      width: cardWidth,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(fontSize: 40),
                            ),
                            const Divider(color: Colors.black),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "E-mail",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegExp =
                                    RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPass
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              obscureText: showPass,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 232, 223, 202),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _login();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Text(
                                          "Please fill the above fields",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Login"),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Not a member? '),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, AppRoutes.signUp),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
