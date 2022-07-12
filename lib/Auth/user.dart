import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final User user;
  const UserPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user.email!),
            ElevatedButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              label: const Text("Logout"),
              icon: const Icon(Icons.lock),
            )
          ],
        ),
      ),
    );
  }
}
