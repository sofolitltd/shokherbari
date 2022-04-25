import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '/admin/provider_admin/banner_provider.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({Key? key}) : super(key: key);

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? selectedImage;
  bool isUpload = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Banner'),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Banner Title',
                label: Text('Banner Title'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) => value!.isEmpty ? 'Enter title' : null,
            ),

            const SizedBox(height: 16),

            //
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                //
                selectedImage == null
                    ? Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Text('No image selected'),
                      )
                    : SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),

                //
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: FloatingActionButton(
                    onPressed: () async {
                      addImage();
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),

            const SizedBox(height: 16),

            //
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  if (_globalKey.currentState!.validate()) {
                    if (selectedImage == null) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'No image selected');
                    } else {
                      String bannerTitle = _nameController.text.trim();
                      //
                      setState(() => isUpload = true);

                      //
                      await uploadImage(bannerTitle);

                      //
                      setState(() => isUpload = false);
                    }
                  }
                },
                child: isUpload
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text('Add Banner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //add image
  addImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  //upload image
  uploadImage(bannerTitle) async {
    String uid = const Uuid().v1();

    //
    var ref = FirebaseStorage.instance.ref('Banner').child('$uid.jpg');
    //
    await ref.putFile(selectedImage!).whenComplete(() async {
      var imageUrl = await ref.getDownloadURL();

      // add banner
      await BannerProvider.addBanner(
          uid: uid, bannerTitle: bannerTitle, imageUrl: imageUrl);
      Navigator.pop(context);
    });
  }
}
