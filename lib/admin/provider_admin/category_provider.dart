import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '/utils/constrains.dart';

class CategoryProvider {
  // addCategory
  static addCategory(
      {required String uid,
      required String categoryName,
      required String imageUrl}) {
    String id = const Uuid().v1();

    //
    MyRepo.refCategories.doc(id).set({
      'name': categoryName,
      'image': imageUrl,
    }).then((value) {
      Fluttertoast.showToast(msg: 'Upload category successfully');
    });
  }

  //removeFromCategory
  static removeFromCategory({required String id}) async {
    await MyRepo.refCategories.doc(id).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from category');
    });
  }

  //removeCategoryImage
  static removeCategoryImage({required String imageUrl}) async {
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }
}
