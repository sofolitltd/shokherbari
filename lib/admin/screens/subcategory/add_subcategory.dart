import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokher_bari/utils/constrains.dart';
import 'package:uuid/uuid.dart';

import '../../provider_admin/subcategory_provider.dart';

class AddSubcategory extends StatefulWidget {
  const AddSubcategory(
      {Key? key, required this.category, required this.categoryId})
      : super(key: key);
  final String category;
  final String categoryId;

  @override
  State<AddSubcategory> createState() => _AddSubcategoryState();
}

class _AddSubcategoryState extends State<AddSubcategory> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  File? selectedImage;
  bool isUpload = false;

  @override
  Widget build(BuildContext context) {
    // getBrands();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),

      //
      body: Form(
        key: _globalKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            // name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Subcategory',
                label: Text('Subcategory'),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  value!.isEmpty ? 'please enter subcategory' : null,
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

            //
            isUpload
                ? const SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          setState(() => isUpload = true);

                          // upload image and info
                          await uploadImage();

                          //
                          setState(() => isUpload = false);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add Subcategory'),
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
  uploadImage() async {
    String uid = const Uuid().v1();

    var ref = UserRepo.refStorageSubcategories.child('$uid.jpg');
    //
    await ref.putFile(selectedImage!).whenComplete(() async {
      var imageUrl = await ref.getDownloadURL();

      //add sub
      await SubcategoryProvider.addSubcategory(
        category: widget.category,
        subcategoryName: _nameController.text.trim(),
        imageUrl: imageUrl,
      );
    });
  }
}
