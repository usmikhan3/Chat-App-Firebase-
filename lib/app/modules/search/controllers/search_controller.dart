import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;

  var queryBegin = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data) async {
    print("SEARCH: $data");

    if (data.length == 0) {
      queryBegin.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);

      if (queryBegin.length == 0 && data.length == 1) {
        //the function to be executed on the first letter typed

        CollectionReference users = await firestore.collection("users");
        final keyNameResult = await users
            .where("keyName", isEqualTo: data.substring(0, 1).toUpperCase())
            .get();

        print("TOTAL DATA: ${keyNameResult.docs.length}");
        if (keyNameResult.docs.length > 0) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            queryBegin
                .add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print("QUERY RESULT: ");
          print(queryBegin);
        } else {
          print("No result data: ");
        }
      }

      if (queryBegin.length != 0) {
        tempSearch.value = [];
        queryBegin.forEach((element) {
          if (element["name"].startsWith(capitalized)) {
            tempSearch.add(element);
          }
        });
      }
    }

    queryBegin.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
