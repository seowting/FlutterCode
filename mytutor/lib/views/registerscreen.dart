import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/views/loginscreen.dart';
import '../constants.dart';
import 'package:ndialog/ndialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double screenHeight, screenWidth, ctrwidth;
  String pathAsset = 'assets/images/camera.png';
  var _image;
  final TextEditingController _usernameEditingController =
      TextEditingController();
  final TextEditingController _useremailEditingController =
      TextEditingController();
  final TextEditingController _userpasswordEditingController =
      TextEditingController();
  final TextEditingController _userphonenoEditingController =
      TextEditingController();
  final TextEditingController _userhomeaddEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    print("dispose was called");
    _usernameEditingController.dispose();
    _useremailEditingController.dispose();
    _userpasswordEditingController.dispose();
    _userphonenoEditingController.dispose();
    _userhomeaddEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 800) {
      ctrwidth = screenWidth / 1.5;
    }
    if (screenWidth < 800) {
      ctrwidth = screenWidth / 1.1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Account',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
        width: ctrwidth,
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(height: 10),
            Card(
              child: GestureDetector(
                  onTap: () => {_takePictureDialog()},
                  child: SizedBox(
                      height: screenHeight / 2.5,
                      width: screenWidth,
                      child: _image == null
                          ? Image.asset(pathAsset)
                          : Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _usernameEditingController,
              decoration: InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid user name';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _useremailEditingController,
              decoration: InputDecoration(
                  labelText: 'User Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid user email';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _userpasswordEditingController,
              decoration: InputDecoration(
                  labelText: 'User Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid user password';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _userphonenoEditingController,
              decoration: InputDecoration(
                  labelText: 'User Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid user phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: _userhomeaddEditingController,
              minLines: 6,
              keyboardType: TextInputType.text,
              maxLines: 6,
              decoration: InputDecoration(
                  labelText: 'User Home Address',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Icons.home)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid user home address';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: screenWidth,
              height: 35,
              child: ElevatedButton(
                child: const Text("Register",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                onPressed: () {
                  _registerDialog();
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Already Register? ",
                    style: TextStyle(
                      fontSize: 14,
                    )),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const LoginScreen()))
                  },
                  child: const Text(
                    "Login Here",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ]),
        ),
      ))),
    );
  }

  _takePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.redAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _registerDialog() {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Register Account",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text("Confirm register a new account?",
                style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _registerAccount();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _registerAccount() {
    String _username = _usernameEditingController.text;
    String _useremail = _useremailEditingController.text;
    String _userpassword = _userpasswordEditingController.text;
    String _userphoneno = _userphonenoEditingController.text;
    String _userhomeaddress = _userhomeaddEditingController.text;
    String base64Image = base64Encode(_image!.readAsBytesSync());
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress..."),
        title: const Text("Registering..."));
    progressDialog.show();
    http.post(
        Uri.parse(
            CONSTANTS.server + "/mytutor/mobile/php/register_account.php"),
        body: {
          "name": _username,
          "email": _useremail,
          "password": _userpassword,
          "phoneno": _userphoneno,
          "homeaddress": _userhomeaddress,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Register Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        progressDialog.dismiss();
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: data['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        progressDialog.dismiss();
        return;
      }
    });
  }
}
