import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/database_handler.dart';
import 'auth_service.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final DatabaseHandler _dbHandler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/photos/pomodoro_logo.png', height: 100),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        iconColor: Theme.of(context).primaryColorLight,
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(
                            color: Colors.black38),
                        icon: Icon(Icons.email),
                        filled: true,
                        fillColor: Theme.of(context).primaryColorDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), 
                          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter an email' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        iconColor: Theme.of(context).primaryColorLight,
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                            color: Colors.black38),
                        icon: Icon(Icons.lock),
                        filled: true,
                        fillColor: Theme.of(context).primaryColorDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), 
                          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).primaryColorLight,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            String? uid = await _dbHandler.signIn(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
                            if (_auth.currentUser != null && uid != null) {
                              Navigator.pushReplacementNamed(
                                  context, '/home');
                            } 
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                      child: Text('Sign In'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColorLight
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text('Create an account here. Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}