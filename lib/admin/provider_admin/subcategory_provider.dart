import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/utils/constrains.dart';

class SubcategoryProvider {
  //add sub category
  static addSubcategory({
    required String category,
    required String subcategoryName,
    required String imageUrl,
  }) async {
    await MyRepo.refSubcategories.doc().set(
      {'category': category, 'name': subcategoryName, 'image': imageUrl},
    ).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Add subcategory successfully');
    });
  }

  //removeFromSubcategory
  static removeFromSubcategory({required String subcategoryId}) async {
    await MyRepo.refSubcategories.doc(subcategoryId).delete().then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Remove from subcategory');
    });
  }

  //removeCategoryImage
  static removeSubcategoryImage({required String imageUrl}) async {
    await FirebaseStorage.instance
        .refFromURL(imageUrl)
        .delete()
        .then((value) {});
  }
}
