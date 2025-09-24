import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solace/screens/home_screen.dart';
import 'package:solace/screens/login_page.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return const LoginPage();
        }
        // User is signed in
        return const HomeScreen();
      },
    );
  }
}
