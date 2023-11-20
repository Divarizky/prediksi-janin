import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/view/profil/profil.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class EditProfil extends StatefulWidget {
  EditProfil({
    super.key,
    required this.nama,
    required this.email,
    required this.no,
    this.image,
  });
  final String nama;
  final String email;
  final String no;
  final String? image;

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namaUController = TextEditingController();
  TextEditingController noUController = TextEditingController();
  TextEditingController emailUController = TextEditingController();
  XFile? pickedimage;
  File? fileimage;

  Future<void> pickImageCamera() async {
    final XFile? pickerImageCamera =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickerImageCamera != null) {
      final File fileImage = File(pickerImageCamera.path);
      setState(() {
        pickedimage = pickerImageCamera;
        fileimage = fileImage;
      });
    }
  }

  Future<void> pickImageGallery() async {
    final XFile? pickerImageGallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickerImageGallery != null) {
      final File fileImage = File(pickerImageGallery.path);
      setState(() {
        pickedimage = pickerImageGallery;
        fileimage = fileImage;
      });
    }
  }

  @override
  void initState() {
    namaUController.text = widget.nama;
    noUController.text = widget.no;
    emailUController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    void bottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  pickImageCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.filter),
                title: const Text("Gallery"),
                onTap: () {
                  pickImageGallery();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: pinkColor,
          ),
        ),
        title: Text(
          'Edit Profil',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    fileimage != null
                        ? Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(fileimage!),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                              image: DecorationImage(
                                image: AssetImage("assets/image/person.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                    Positioned(
                      child: IconButton(
                        onPressed: () {
                          bottomSheet();
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ),
                      ),
                      left: 140,
                      bottom: 7,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama Lengkap',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: namaUController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Nomor Hp',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: noUController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Email',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: emailUController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  width: 277,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // side: BorderSide(
                      //   width: 1,
                      // ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: pinkColor,
                    ),
                    onPressed: () async {
                      var imageName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      var storageRef = FirebaseStorage.instance
                          .ref()
                          .child('profil/$imageName.jpg');
                      var uploadTask = storageRef.putFile(fileimage!);
                      var downloadUrl =
                          await (await uploadTask).ref.getDownloadURL();
                      auth.updateDetailsToFirestore(
                        emailUController.text,
                        namaUController.text,
                        noUController.text,
                        downloadUrl,
                        context,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profil(),
                        ),
                      );
                    },
                    child: Text(
                      'Simpan',
                      style: buttonText.copyWith(color: whiteColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
