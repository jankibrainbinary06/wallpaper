import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  bool isCategory = true;
  bool isImages = false;
  bool isLogout = false;
  bool isDrop = false;
  bool isUploaded = false;
  String category = '4k Wallpaper';


  String selectedCategory = '';
  int lengthOfImage = 0;
  bool loader = false;
  List categoryName = [];
  List downloadUrlList = [];

  TextEditingController editingController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  final uuid = const Uuid();

  CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('category');

  Future<void> onTapCategoryUpload(String name) {
    return categoryCollection
        .add({
          'name': name,
          'image': [],
          'checkBool': false,
        })
        .then((value) {})
        .catchError((error) {});
  }

  onTapCategoryEdit(String name, String? id, List image) {
    categoryCollection
        .doc(id)
        .update({
          'name': name,
          'image': image,
        })
        .then((_) {})
        .catchError((error) {});
  }

  onTapCategoryDelete(String? id) async {
    await categoryCollection.doc(id).delete();
  }

  Future<void> removeItemAtIndex(String? id, List images, int index) async {
    images.removeAt(index);
    await categoryCollection.doc(id).update({'image': images});
  }

  Future uploadImage(List image) async {
loader = true ;
update(['home']);

var list = [];

    downloadUrlList.clear();
    var listData = [];
   await  categoryCollection.doc(selectedCategory).get().then((value) async {
      listData =  value.get('image');
    });
    print(listData);
    try {
      downloadUrlList.addAll(listData);

for(int i =0 ; i < image.length; i++){
  final uniqueImageName = uuid.v4();
  Reference storageRef =
  FirebaseStorage.instance.ref().child('images/$uniqueImageName');
  UploadTask uploadTask = storageRef.putData(image[i]);
  String imageUrl;
  final snapshot = await uploadTask;
  imageUrl = await snapshot.ref.getDownloadURL();
print(imageUrl);

list.add(imageUrl);


}
for(int i = 0;i< list.length; i++  ){
  downloadUrlList.add({

    'imageLink' : list[i],
    'isFav': false,
  });
}

    } catch (error) {
      return;
    }
    await onTapCategoryEdit(category, selectedCategory, downloadUrlList);
    loader = false ;
    update(['home']);

  }
}
