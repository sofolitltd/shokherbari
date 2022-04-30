import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shokher_bari/utils/constrains.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController searchString = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: searchString,
          autofocus: true,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search product',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white),
            suffixIcon: searchString.text.isNotEmpty
                ? IconButton(
                    onPressed: () => searchString.clear(),
                    icon: const Icon(Icons.clear),
                    color: Colors.white)
                : null,
          ),
          textCapitalization: TextCapitalization.words,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),

      //
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        tempSearchStore = []; //comment this if you want to always show.
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    tempSearchStore = [];
    for (var element in queryResultSet) {
      if (element['name'].startsWith(capitalizedValue)) {
        setState(() {
          tempSearchStore.add(element);
        });
      }
    }
  }

  _getSnapShots() {
    SearchService().searchByName().map((snapshot) {
      snapshot.then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    }).toList();
  }

  @override
  void initState() {
    _getSnapShots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: TextField(
            autofocus: true,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white)),
            onChanged: (val) {
              initiateSearch(val.toUpperCase());
            },
          ),
        ),
        body: ListView(
            padding: const EdgeInsets.all(8),
            children: tempSearchStore.map((data) {
              return GestureDetector(
                onTap: () {
                  // ProductModel product = ProductModel.fromSnapshot(data);
                  // print(product.weight);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => ProductDetails(product: product)));
                },
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              //cat
                              Text(
                                data['category'],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 10,
                                ),
                              ),

                              //sub
                              Text(
                                data['subcategory'],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          //name, image
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //image
                              Image.network(
                                data['images'][0],
                                height: 56,
                                width: 64,
                                fit: BoxFit.cover,
                              ),

                              const SizedBox(width: 8),

                              // name, price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // name
                                  Text(
                                    data['name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),

                                  // weight, price
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // weight
                                      Text(
                                        data['weight'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text('|'),
                                      ),

                                      // sale price
                                      Text(
                                        kTk + data['salePrice'].toString(),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      // regular price
                                      Text(
                                        kTk + data['regularPrice'].toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              );
            }).toList()));
  }
}

class SearchService {
  List<Future<QuerySnapshot>> searchByName() {
    return [UserRepo.refProducts.where('searchKey').get()];
  }
}
