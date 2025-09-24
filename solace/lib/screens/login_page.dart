import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String? _errorMessage;
  bool _isLoading = false;
  bool _isSignUp = false; // Toggle between sign in and sign up

  Future<void> _signInWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    
    try {
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _registerWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    
    try {
      await _authService.registerWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   setState(() {
  //     _errorMessage = null;
  //     _isLoading = true;
  //   });
    
  //   // try {
  //   //   await _authService.signInWithGoogle();
  //   // } catch (e) {
  //   //   setState(() {
  //   //     _errorMessage = e.toString();
  //   //   });
  //   // } finally {
  //   //   if (mounted) {
  //   //     setState(() {
  //   //       _isLoading = false;
  //   //     });
  //   //   }
  //   // }
  // }

  void _toggleSignUpMode() {
    setState(() {
      _isSignUp = !_isSignUp;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title
                Image(image: AssetImage("assets/solace_logo.png"),
                  height: 70,
                ),
                Text(
                  'Solace',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  'A private space to reflect and be heard.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 48),
                
                // Error Message
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                
                // Main Action Button (Sign In / Sign Up)
                ElevatedButton(
                  onPressed: _isLoading ? null : (_isSignUp ? _registerWithEmailAndPassword : _signInWithEmailAndPassword),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isSignUp ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 15),
                
                // Toggle Sign In/Sign Up
                TextButton(
                  onPressed: _isLoading ? null : _toggleSignUpMode,
                  child: Text(
                    _isSignUp 
                        ? 'Already have an account? Sign In'
                        : 'Don\'t have an account? Sign Up',
                  ),
                ),
                // const SizedBox(height: 30),
                
                // // Divider
                // const Row(
                //   children: [
                //     Expanded(child: Divider()),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 16),
                //       child: Text('OR'),
                //     ),
                //     Expanded(child: Divider()),
                //   ],
                // ),
                // const SizedBox(height: 20),
                
                // // Google Sign In Button
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: OutlinedButton.icon(
                //     onPressed: _isLoading ? null : _signInWithGoogle,
                //     icon: Image.asset(
                //       'assets/images/google_logo.png', // You'll need to add this asset
                //       height: 24,
                //       width: 24,
                //       errorBuilder: (context, error, stackTrace) {
                //         return const Icon(Icons.login, size: 24);
                //       },
                //     ),
                //     label: const Text(
                //       'Continue with Google',
                //       style: TextStyle(fontSize: 16),
                //     ),
                //     style: OutlinedButton.styleFrom(
                //       side: BorderSide(
                //         color: Theme.of(context).colorScheme.outline,
                //       ),
                //     ),
                //   ),
                // ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}