import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({Key? key}) : super(key: key);
  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final storageRef = FirebaseStorage.instance.ref();
  TextEditingController usernameController = TextEditingController(
    text: FirebaseAuth.instance.currentUser!.displayName!,
  );
  TextEditingController emailController = TextEditingController(
    text: FirebaseAuth.instance.currentUser!.email!,
  );
  TextEditingController passwordController = TextEditingController();
  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  ImagePicker picker = ImagePicker();

  void showLoadingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  void showErrorDialog(String error) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    signInEmailController.dispose();
    signInPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit your profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: CupertinoButton(
              child: const Text("Save new username"),
              onPressed: () async {
                showLoadingDialog();
                await FirebaseAuth.instance.currentUser!.updateDisplayName(
                  usernameController.text.trim(),
                );
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: CupertinoButton(
              child: const Text("Save new email"),
              onPressed: () async {
                showLoadingDialog();
                await FirebaseAuth.instance.currentUser!.updateEmail(
                  emailController.text.trim(),
                );
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: CupertinoButton(
              child: const Text("Save new password"),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Enter your login informations please"),
                    content: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextField(
                            controller: signInEmailController,
                            decoration:
                                const InputDecoration(labelText: "Email"),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextField(
                            controller: signInPasswordController,
                            decoration:
                                const InputDecoration(labelText: "Password"),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          try {
                            Navigator.pop(context);
                            showLoadingDialog();
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: signInEmailController.text.trim(),
                              password: signInPasswordController.text.trim(),
                            );
                            await FirebaseAuth.instance.currentUser!
                                .updatePassword(
                              passwordController.text.trim(),
                            );
                            signInEmailController.clear();
                            emailController.clear();
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            Navigator.pop(context);
                            showErrorDialog(e.message!);
                          } catch (e) {
                            Navigator.pop(context);
                            showErrorDialog(e.toString());
                          }
                        },
                        child: const Text("Validate"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
                  showLoadingDialog();
                  if (FirebaseAuth.instance.currentUser!.photoURL != null) {
                    await FirebaseStorage.instance
                        .refFromURL(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                        )
                        .delete();
                  }
                  await pfpRef.putFile(File(pfpRef.fullPath)).then((p0) async {
                    await FirebaseAuth.instance.currentUser!.updatePhotoURL(
                      await p0.ref.getDownloadURL(),
                    );
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}
