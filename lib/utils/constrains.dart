import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const kBrandName = 'Shokher Bari';
const kTk = '৳';

class MyRepo {
  static User user = FirebaseAuth.instance.currentUser!;

  //user
  static String userEmail = user.email.toString();

  // firestore
  static final ref = FirebaseFirestore.instance;

  //storage
  static final refStorage = FirebaseStorage.instance;

  // banner
  static final refBanner = MyRepo.ref.collection('Banner');

  //categories
  static final refCategories = MyRepo.ref.collection('Categories');

  //storage categories
  static final refStorageCategories = MyRepo.refStorage.ref('Categories');

  //categories
  static final refSubcategories = MyRepo.ref.collection('Subcategories');

  //storage subcategories
  static final refStorageSubcategories =
      refStorageCategories.child('Subcategories');

  // product
  static final refProducts = MyRepo.ref.collection('Products');

  // storage product
  static final refStorageProducts = MyRepo.refStorage.ref('Products');

  // refCart
  static final refCart =
      MyRepo.ref.collection('Users').doc(MyRepo.userEmail).collection('Cart');

  //refWishlist
  static final refWishlist = MyRepo.ref
      .collection('Users')
      .doc(MyRepo.userEmail)
      .collection('Wishlist');

  //orders
  static final refOrder = MyRepo.ref.collection('Orders');

  //payment
  static final refPayment = MyRepo.ref.collection('Payment');

  // refAddress
  static final refAddress = MyRepo.ref
      .collection('Users')
      .doc(MyRepo.userEmail)
      .collection('Address');

  //refAddress hall
  static final refAddressHall = refAddress.doc('Hall');

  //refAddress home
  static final refAddressHome = refAddress.doc('Home');

  // short by list
  static final List<String> shortByList = [
    'All',
    'Featured',
    'Price, low to high',
    'Price, high to low',
  ];

  //
  static const kBkashAccount = '01704340860';

  //
  static const kOrderStatus = 'Pending';
}
