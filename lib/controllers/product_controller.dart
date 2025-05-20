import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/controllers/HomeController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../const/const.dart';
import '../const/fire_base_constants.dart';
import '../models/category_model.dart';
import 'package:path/path.dart';

class ProductController extends GetxController {
  static final ImagePicker _picker = ImagePicker();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var quantityController = TextEditingController();
  var imagePath = ''.obs;
  var categoryList = <String>[].obs;
  var subCategoryList = <String>[].obs;
  List<Category> category = [];
   var pImages = <File>[].obs;
  var pImagesLinks =[];
  var categoryValue = ''.obs;
  var subCategoryValue = ''.obs;
  var selectedColorIndex = 0.obs;
  var isLoading = false.obs;
  var handmadeOrVintage = ''.obs;
  var uniqueness = ''.obs;
  var limitedEdition = ''.obs;
  var additionalNotes = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  getCategories() async {
    category.clear();
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var cat = categoryModelFromJson(data);
    category = cat.categories;
    populateCategoryList();
  }

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubCategoryList(String cat) {
    subCategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();
    if (data.isNotEmpty) {
      subCategoryList.addAll(data.first.subcategory);
    }
  }

  selectedIndex(int index) {
    selectedColorIndex.value = index;
  }

  static Future<File> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 800,
      quality: 25,
      format: CompressFormat.jpeg,
    );
    return File(file.absolute.path)..writeAsBytesSync(result!);
  }

   Future<List<File>> pickMultipleImages({required BuildContext context}) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isEmpty) return [];
      if (pickedFiles.length > 4) {

      }
      final List<XFile> limitedFiles = pickedFiles.take(4).toList();
      List<File> compressedFiles = [];
      for (var xFile in limitedFiles) {File imageFile = File(xFile.path);compressedFiles.add(await _compressImage(imageFile));}
      pImages.value = compressedFiles;
      return compressedFiles;
    } catch (error) {
      return [];
    }
  }

  static Future<String?> uploadFile({
    required String userId,
    required String category,
    required File file,
    required BuildContext context,
  }) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final filePath = '$userId/$category/$fileName';
      await AppConstants.supaBase.storage.from(AppConstants.firebaseBucket).upload(filePath, file);
      final publicUrl = AppConstants.supaBase.storage.from(AppConstants.firebaseBucket).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

   Future<List<String>> uploadImages({
    required BuildContext context,
    required List<File> images,
  }) async {
    List<String> imagesLinks = [];
    List<Future<String?>> uploadImageTasks = images.map((image) async {
      String? imageUrl = await uploadFile(
        userId: currentUser!.uid,
        category: AppConstants.pictures,
        file: image,
        context: context,
      );
      return (imageUrl != null && imageUrl.isNotEmpty) ? imageUrl : null;
    }).toList();

    List<String?> results = await Future.wait(uploadImageTasks);
    pImagesLinks.addAll(results);
    return imagesLinks;
  }







  uploadProduct() async {
    try{
      isLoading(true);
      var store =  fireStore.collection(productsCollections).doc();
      await store.set({
        'id_featured':false,
        'p_category':categoryValue.value,
        'p_subcategory':subCategoryValue.value,
        'p_price':priceController.text,
        'p_quantity':quantityController.text,
        'p_description':descriptionController.text,
        'vendor_id':currentUser!.uid,
        'p_colors':FieldValue.arrayUnion([Colors.purple.value,Colors.orangeAccent.value,Colors.red.value]),
        'p_rating':'',
        'p_wishList':FieldValue.arrayUnion([]),
        'p_images':FieldValue.arrayUnion(pImagesLinks),
        'p_name': nameController.text.toString(),
        'p_seller':Get.find<HomeController>().shopName,
      });
      isLoading(false);
      pImagesLinks.clear();
    }catch(e){
      print(e);
      isLoading(false);

    }
  }

  markFeatured(docId) async {
   try{
     var store = fireStore.collection(productsCollections).doc(docId);
     await store.set({
       'featured_id':currentUser!.uid,
       'id_featured':'true',
     },SetOptions(merge: true));
   }catch(e){
     print(e);
   }
  }

  unMarkFeatured(docId) async {
    try{
      var store = fireStore.collection(productsCollections).doc(docId);
      await store.set({
        'featured_id':'',
        'id_featured':'false',
      },SetOptions(merge: true));
    }catch(e){
      print(e);
    }
  }

  deleteProduct(docId) async {
    try{
      await fireStore.collection(productsCollections).doc(docId).delete();
    }catch(e){

    }

  }
}
