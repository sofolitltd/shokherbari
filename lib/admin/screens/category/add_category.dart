import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/constrains.dart';
import '../../provider_admin/category_provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
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
        title: const Text('Add Category'),
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
                hintText: 'Category',
                label: Text('Category'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) => value!.isEmpty ? 'Enter category' : null,
            ),

            const SizedBox(height: 16),

            // image
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                //
                selectedImage == null
                    ? Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Text('No image selected'),
                      )
                    : SizedBox(
                        height: 200,
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

            // add category btn
            isUpload
                ? const SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  )
                : SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          if (selectedImage == null) {
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(msg: 'No image selected');
                          } else {
                            String categoryName = _nameController.text.trim();
                            //
                            setState(() => isUpload = true);
                            await uploadImage(categoryName);
                            setState(() => isUpload = false);
                          }
                        }
                      },
                      child: const Text('Add Category'),
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
  uploadImage(categoryName) async {
    String uid = const Uuid().v1();

    var ref = UserRepo.refStorageCategories.child('$uid.jpg');
    //
    await ref.putFile(selectedImage!).whenComplete(() async {
      var imageUrl = await ref.getDownloadURL();

      // add category
      await CategoryProvider.addCategory(
          uid: uid, categoryName: categoryName, imageUrl: imageUrl);
      Navigator.pop(context);
    });
  }
}
