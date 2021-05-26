import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/components/stateful_builder.dart';
import 'package:touroll/screens/me/update_password.dart';
import 'package:touroll/services/auth.dart';
import 'package:touroll/services/upload.dart';
import 'package:touroll/services/user.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService authService = AuthService();
  final uploadService = UploadService();
  final userService = UserService();
  File _image;
  final picker = ImagePicker();
  bool uploadingIcon = false;

  void requestIconUpdate() async {
    setState(() {
      uploadingIcon = true;
    });
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      _image = File(pickedFile.path);
      //
      final id = await uploadService.upload(_image);
      await userService.updateMe(icon: id);
    } catch (ex) {
      print(ex.toString());
    }
    setState(() {
      uploadingIcon = false;
    });
  }

  Future<String> _getBio() async {
    return (await userService.getProfile()).about;
  }

  Future<void> updateBio(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          bool updatingBio = false;
          Future<String> bio = _getBio();
          return FutureBuilder(
              future: bio,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  TextEditingController bioFieldController =
                      TextEditingController(text: snapshot.data);
                  return CustomStatefulBuilder(
                      dispose: () {
                        bioFieldController.dispose();
                      },
                      builder: (context, setState) => AlertDialog(
                            title: Text('Update bio'),
                            content: TextField(
                              controller: bioFieldController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText: "Type your bio here..."),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('CANCEL'),
                                onPressed: updatingBio
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                      },
                              ),
                              TextButton(
                                child: Text('OK'),
                                onPressed: updatingBio
                                    ? null
                                    : () async {
                                        setState(() {
                                          updatingBio = true;
                                        });
                                        try {
                                          await userService.updateMe(
                                              about: bioFieldController.text);
                                        } catch (ex) {
                                          print(ex);
                                        }
                                        Navigator.pop(context);
                                        setState(() {
                                          updatingBio = false;
                                        });
                                      },
                              ),
                            ],
                          ));
                } else
                  return AlertDialog(
                      content: Center(
                    child: Loading(),
                    heightFactor: 1.1,
                  ));
              });
        });
  }

  Future<void> rename(BuildContext context) async {
    final currentName = fa.FirebaseAuth.instance.currentUser?.displayName;
    return showDialog(
      context: context,
      builder: (context) {
        bool updatingName = false;
        TextEditingController nameFieldController = TextEditingController();
        nameFieldController.text = currentName;
        return CustomStatefulBuilder(dispose: () {
          nameFieldController.dispose();
        }, builder: (context, setState) {
          return AlertDialog(
            title: Text('Rename'),
            content: TextField(
              controller: nameFieldController,
              decoration: InputDecoration(hintText: "Type your name here..."),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: updatingName
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: updatingName
                    ? null
                    : () async {
                        setState(() {
                          updatingName = true;
                        });
                        try {
                          await userService.updateMe(
                              name: nameFieldController.text);
                          await fa.FirebaseAuth.instance.currentUser
                              .updateProfile(
                                  displayName: nameFieldController.text);
                          Navigator.pop(context);
                        } catch (ex) {}
                        setState(() {
                          updatingName = false;
                        });
                      },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoginOnly(
        builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Account'),
            ),
            body: Container(
              child: ListView(
                children: [
                  Container(
                    height: 160,
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 96,
                              width: 96,
                              child: Material(
                                borderRadius: BorderRadius.circular(48),
                                color: Colors.black12,
                                child: uploadingIcon
                                    ? Loading()
                                    : InkWell(
                                        onTap: () {
                                          requestIconUpdate();
                                        },
                                        child: fa.FirebaseAuth.instance
                                                    .currentUser?.photoURL !=
                                                null
                                            ? ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: fa
                                                      .FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.photoURL,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      height: 96,
                                                      width: 96,
                                                      child: Material(
                                                        color: Colors.grey,
                                                        child: InkWell(
                                                          onTap: () {
                                                            requestIconUpdate();
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container()),
                              ),
                            ),
                            Container(height: 10),
                            GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    fa.FirebaseAuth.instance.currentUser
                                            ?.displayName ??
                                        'No name',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              onTap: () {
                                requestIconUpdate();
                              },
                            )
                          ]),
                    ),
                  ),
                  ListTile(
                      title: Text('Update name'), onTap: () => rename(context)),
                  ListTile(
                      title: Text('Update bio'),
                      onTap: () => updateBio(context)),
                  ListTile(
                    title: Text('Reset password'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => UpdatePasswordScreen()));
                    },
                  ),
                  ListTile(
                    title: Text('Sign Out'),
                    onTap: () {
                      authService.signOut();
                    },
                  )
                ],
              ),
            )));
  }
}
