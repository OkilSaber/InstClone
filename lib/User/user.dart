import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/User/user_edit.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (() => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const UserEdit(),
                  ),
                ).then(
                  (value) => setState(() {
                    user = FirebaseAuth.instance.currentUser!;
                  }),
                )),
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.01),
              CircleAvatar(
                radius: 75,
                child: ClipOval(
                  child: user.photoURL != null
                      ? Image.network(
                          user.photoURL!,
                        )
                      : const Icon(Icons.people_rounded),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                user.displayName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              CupertinoButton.filled(
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
            ],
          ),
        ),
      ),
    );
  }
}
