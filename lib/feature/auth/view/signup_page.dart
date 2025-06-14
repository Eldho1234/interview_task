import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_routes.dart';
import 'package:interview_task/feature/auth/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final userNamController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _signUp() async {
    final username = userNamController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    await auth.signUp(username, email, password);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          "Signup Successful",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    userNamController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    left: 20,
                    right: 20,
                    top: 40,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: cardWidth),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Please fill in the form to create an account!',
                                style: TextStyle(fontSize: 16),
                              ),
                              const Divider(color: Colors.black),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: userNamController,
                                decoration:
                                    const InputDecoration(labelText: "Name"),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: emailController,
                                decoration:
                                    const InputDecoration(labelText: "E-mail"),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegExp = RegExp(
                                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegExp.hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: "Password"),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: confirmPassController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    labelText: "Confirm Password"),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 232, 223, 202),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _signUp();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            "Please fill the above fields",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text("Sign Up"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already a member? '),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, AppRoutes.login),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
