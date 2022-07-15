import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends StatefulWidget {
  final User user = FirebaseAuth.instance.currentUser!;

  UserPage({Key? key}) : super(key: key);
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final storageRef = FirebaseStorage.instance.ref();
  ImagePicker picker = ImagePicker();
  Widget pfp = FirebaseAuth.instance.currentUser!.photoURL != null
      ? Image.network(FirebaseAuth.instance.currentUser!.photoURL!)
      : const Icon(Icons.people_rounded);

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
            onPressed: (() {}),
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
                  child: pfp,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                widget.user.displayName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: CupertinoButton.filled(
                  child: const Text("Choose a profile picture"),
                  onPressed: () async {
                    final newPic = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (newPic != null) {
                      final pfpRef = storageRef.child(newPic.path);
                      await pfpRef
                          .putFile(File(pfpRef.fullPath))
                          .then((p0) async {
                        await FirebaseAuth.instance.currentUser!.updatePhotoURL(
                          await p0.ref.getDownloadURL(),
                        );
                        setState(() {
                          pfp = Image.network(
                            FirebaseAuth.instance.currentUser!.photoURL!,
                          );
                        });
                      });
                    }
                  },
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
