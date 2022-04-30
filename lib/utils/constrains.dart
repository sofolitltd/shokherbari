import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const kBrandName = 'Shokher Bari';
const kTk = '৳';

//admin
const kBkashAccount = '01780658655';
const kMobileAdmin = '01780658655';
const kMobileAddress = 'Anonto, Pabna';

//
const kOrderStatus = 'Pending';

// short by list
const List<String> shortByList = [
  'All',
  'Featured',
  'Price, low to high',
  'Price, high to low',
];

class UserRepo {
  static User user = FirebaseAuth.instance.currentUser!;

  //user
  static String userEmail = user.email.toString();

  // firestore
  static final ref = FirebaseFirestore.instance;

  //storage
  static final refStorage = FirebaseStorage.instance;

  // banner
  static final refBanner = ref.collection('Banner');

  //categories
  static final refCategories = ref.collection('Categories');

  //storage categories
  static final refStorageCategories = refStorage.ref('Categories');

  //categories
  static final refSubcategories = ref.collection('Subcategories');

  //storage subcategories
  static final refStorageSubcategories =
      refStorageCategories.child('Subcategories');

  // product
  static final refProducts = ref.collection('Products');

  // storage product
  static final refStorageProducts = refStorage.ref('Products');

  // refCart
  static final refCart =
      ref.collection('Users').doc(userEmail).collection('Cart');

  //refWishlist
  static final refWishlist =
      ref.collection('Users').doc(userEmail).collection('Wishlist');

  //orders
  static final refOrder = ref.collection('Orders');

  //payment
  static final refPayment = ref.collection('Payment');

  // refuser
  static final refUser = ref.collection('Users').doc(userEmail);

  // refAddress
  static final refAddress =
      ref.collection('Users').doc(userEmail).collection('Address');

  //refAddress hall
  static final refAddressHall = refAddress.doc('Hall');

  //refAddress home
  static final refAddressHome = refAddress.doc('Home');

  // refDelivery
  static final refDelivery = ref.collection('Extra').doc('Delivery');
}
