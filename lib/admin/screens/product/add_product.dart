import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shokher_bari/admin/screens/category/all_category_admin.dart';
import 'package:uuid/uuid.dart';

import '/models/product_model.dart';
import '/utils/constrains.dart';
import '../../provider_admin/product_provider_admin.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  late int _isSelected = 1;
  String? _selectedSubcategory;
  String uid = const Uuid().v1();

  List categoryList = [];
  String? _selectedCategory;

  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  int _uploadItem = 0;
  bool _isUploadLoading = false;

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _regularPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getBrands('Cloth');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllCategoryAdmin()));
              },
              icon: const Icon(Icons.add)),
        ],
      ),

      //
      body: _isUploadLoading
          ? showLoading()
          : Form(
              key: _globalKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // category list
                      DropdownButtonFormField(
                        hint: const Text('Select Category'),
                        value: _selectedCategory,
                        items: categoryList
                            .map((item) => DropdownMenuItem<String>(
                                value: item, child: Text(item)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCategory = null;
                            _selectedSubcategory = null;
                            _selectedCategory = value!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'please select a category' : null,
                      ),

                      if (_selectedCategory != null) const SizedBox(height: 8),

                      // subcategory
                      if (_selectedCategory != null)
                        StreamBuilder<QuerySnapshot>(
                          stream: MyRepo.refSubcategories
                              .where('category', isEqualTo: _selectedCategory)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Some thing went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // loading state
                              return DropdownButtonFormField(
                                hint: const Text('Select Subcategory'),
                                items: [].map((item) {
                                  // category name
                                  return DropdownMenuItem<String>(
                                      value: item, child: Text(item));
                                }).toList(),
                                onChanged: (String? value) {},
                              );
                            }

                            // select sub
                            return DropdownButtonFormField(
                              hint: const Text('Select Subcategory'),
                              value: _selectedSubcategory,
                              items: snapshot.data!.docs.map((item) {
                                // category name
                                return DropdownMenuItem<String>(
                                    value: item.get('name'),
                                    child: Text(item.get('name')));
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedSubcategory = value!;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'please select a subcategory'
                                  : null,
                            );
                          },
                        ),

                      const SizedBox(height: 8),

                      // name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Product Name',
                          label: Text('Product Name'),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter product name' : null,
                      ),

                      const SizedBox(height: 8),

                      // description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Product Description',
                          label: Text('Product Description'),
                        ),
                        minLines: 2,
                        maxLines: 12,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.none,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter product description' : null,
                      ),

                      const SizedBox(height: 8),

                      // regular and sale price
                      Row(
                        children: [
                          // sale price
                          Expanded(
                            child: TextFormField(
                              controller: _salePriceController,
                              decoration: const InputDecoration(
                                hintText: 'Sale Price',
                                label: Text('Sale Price'),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter price' : null,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // regular price
                          Expanded(
                            child: TextFormField(
                              controller: _regularPriceController,
                              decoration: const InputDecoration(
                                hintText: 'Regular Price',
                                label: Text('Regular Price'),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // price, quantity, weight
                      Row(
                        children: [
                          // quantity
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(
                                hintText: 'Quantity',
                                label: Text('Quantity'),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter quantity' : null,
                            ),
                          ),

                          const SizedBox(width: 8),

                          // weight
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: _weightController,
                              decoration: const InputDecoration(
                                hintText: 'Weight',
                                label: Text('Weight'),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              // validator: (value) =>
                              //     value!.isEmpty ? 'Enter weight' : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // images
                      OutlinedButton.icon(
                        onPressed: () {
                          addImages();
                        },
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text('Add Image'),
                        ),
                      ),

                      const SizedBox(height: 8),

                      _selectedFiles.isEmpty
                          ? const Text(
                              'No Image Selected',
                              textAlign: TextAlign.center,
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _selectedFiles.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) => Image.file(
                                File(_selectedFiles[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),

                      const SizedBox(height: 8),

                      // featured, sale
                      Row(
                        children: [
                          // featured
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Featured'.toUpperCase()),
                              value: 0,
                              groupValue: _isSelected,
                              onChanged: (value) =>
                                  setState(() => _isSelected = 0),
                            ),
                          ),

                          const SizedBox(width: 8),
                          // sale
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Sale'.toUpperCase()),
                              value: 1,
                              groupValue: _isSelected,
                              onChanged: (value) =>
                                  setState(() => _isSelected = 1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // upload button
                      ElevatedButton(
                          onPressed: () {
                            if (_globalKey.currentState!.validate()) {
                              if (_selectedFiles.isNotEmpty) {
                                //
                                uploadToFirebase();
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please Select Image');
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('Upload Product'),
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // add images
  Future<void> addImages() async {
    if (_selectedFiles.isNotEmpty) {
      _selectedFiles.clear();
    }

    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images! != null) {
        setState(() {
          _selectedFiles.addAll(images);
        });
        // print(_selectedFiles.length);
      }
    } catch (e) {
      print('something wrong$e');
    }
  }

  //loading
  Widget showLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LinearProgressIndicator(
            minHeight: 16,
            valueColor: const AlwaysStoppedAnimation(Colors.green),
            value: _uploadItem / (_selectedFiles.length),
          ),
        ),
        Text(
          'Uploading: $_uploadItem/${_selectedFiles.length}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // uploadImages
  Future uploadToFirebase() async {
    // setState(() {
    //   _isUploadLoading = true;
    // });

    var imageList = [];
    //
    for (var img in _selectedFiles) {
      Reference ref = MyRepo.refStorageProducts.child(uid).child(img.name);

      //
      await ref.putFile(File(img.path)).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imageList.add(value);
          setState(() {
            _uploadItem = imageList.length;
          });
        });
      });
    }

    //
    // _uploadItem = 0;
    uploadToFirestore(imageList);
  }

  // uploadToFirestore
  uploadToFirestore(imageList) async {
    ProductModel product = ProductModel(
      category: _selectedCategory.toString(),
      subcategory: _selectedSubcategory.toString(),
      id: uid,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      salePrice: int.parse(_salePriceController.text.trim()),
      regularPrice: _regularPriceController.text != ''
          ? int.parse(_regularPriceController.text.trim())
          : 0,
      stockQuantity: int.parse(_quantityController.text.trim()),
      featured: _isSelected == 0 ? true : false,
      images: imageList,
      searchKey: _nameController.text[0].toUpperCase(),
      weight: _weightController.text.trim(),
    );

    //addProduct
    await ProductProviderAdmin.addProduct(product: product, uid: uid)
        .then((value) {
      // setState(() => _isUploadLoading = false);
      // Navigator.pop(context);
    });
  }

  // get categories
  getCategory() {
    MyRepo.refCategories
        .orderBy('name')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var category = doc.get('name');
        setState(() {
          categoryList.add(category);
        });
      }
    });
  }
}
