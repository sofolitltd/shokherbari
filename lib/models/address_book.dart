// class AddressBookHome {
//   final String name;
//   final String phone;
//   final String division;
//   final String city;
//   final String area;
//   final String address;
//
//   AddressBookHome({
//     required this.name,
//     required this.phone,
//     required this.division,
//     required this.city,
//     required this.area,
//     required this.address,
//   });
//
//   // upload
//   Map<String, Object> toJson() {
//     return {
//       'name': name,
//       'phone': phone,
//       'division': division,
//       'city': city,
//       'area': area,
//       'address': address
//     };
//   }
//
//   //fetch
//   AddressBookHome.fromJson(Map<String, Object?> json)
//       : this(
//           name: json['name']! as String,
//           phone: json['phone']! as String,
//           division: json['division']! as String,
//           city: json['city']! as String,
//           area: json['area']! as String,
//           address: json['address']! as String,
//         );
// }

// // hall address
// class AddressBookHall {
//   final String name;
//   final String phone;
//   final String hall;
//   final String room;
//
//   AddressBookHall({
//     required this.name,
//     required this.phone,
//     required this.hall,
//     required this.room,
//   });
//
//   // upload
//   Map<String, Object> toJson() {
//     return {
//       'name': name,
//       'phone': phone,
//       'hall': hall,
//       'room': room,
//     };
//   }
//
//   // fetch
//   AddressBookHall.fromJson(Map<String, Object?> json)
//       : this(
//           name: json['name']! as String,
//           phone: json['phone']! as String,
//           hall: json['hall']! as String,
//           room: json['room']! as String,
//         );
// }

// address model
class AddressModel {
  final String name;
  final String phone;
  final String address;
  final String place;

  AddressModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.place,
  });

  // upload
  Map<String, Object> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'place': place,
    };
  }

  // fetch
  AddressModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          phone: json['phone']! as String,
          address: json['address']! as String,
          place: json['place']! as String,
        );
}
