import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user.displayName!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: CupertinoButton.filled(
          child: SizedBox(
            width: 100,
            child: Row(
              children: const [
                Icon(Icons.lock),
                SizedBox(
                  width: 10,
                ),
                Text("Logout"),
              ],
            ),
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ),
    );
  }
}
