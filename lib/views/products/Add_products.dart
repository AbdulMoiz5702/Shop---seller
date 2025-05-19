import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/product_controller.dart';
import 'package:emart_seller/views/widgets_common/customSized.dart';
import 'package:emart_seller/views/widgets_common/customtextField.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets_common/product_drop_down.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        actions: [
          Obx(() =>
          controller.isLoading.value
              ? const Center(child: CupertinoActivityIndicator())
              : TextButton(
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, String>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  final ScrollController scrollController = ScrollController();
                  final textQuestions = [
                    "Condition of the item?",
                    "Approximate age?",
                    "Background/story of the item?",
                    "What material is it made of?",
                    "How should it be cared for?",
                    "Where was it originally made?",
                  ];
                  final dropdownQuestion = {"Is it handmade or vintage?": ["Handmade", "Vintage", "Both"]};
                  final yesNoQuestions = [
                    "Is it one of a kind or limited edition?",
                    "Any damage or wear?",
                    "What inspired you to sell this?",
                  ];
                  final textControllers = Map.fromEntries(textQuestions.map((q) => MapEntry(q, TextEditingController())),);
                  final dropdownSelections = <String, String?>{
                    for (var q in dropdownQuestion.keys) q: null
                  };

                  final yesNoSelections = <String, String?>{
                    for (var q in yesNoQuestions) q: null
                  };

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 20,
                      left: 16,
                      right: 16,
                    ),
                    child: DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.9,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (_, scrollController) => SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: textfieldGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text("Tell us about your product", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: purpleColor)),
                            const SizedBox(height: 16),

                            // TextFields
                            ...textControllers.entries.map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: TextField(
                                controller: entry.value,
                                style: const TextStyle(color: fontGrey),
                                decoration: InputDecoration(
                                  labelText: entry.key,
                                  labelStyle: const TextStyle(color: darkGrey),
                                  filled: true,
                                  fillColor: lightGrey,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: textfieldGrey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: purpleColor),
                                  ),
                                ),
                              ),
                            )),

                            const SizedBox(height: 10),

                            // Dropdown
                            ...dropdownQuestion.entries.map((entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: entry.key,
                                  filled: true,
                                  fillColor: lightGrey,
                                  labelStyle: const TextStyle(color: darkGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: textfieldGrey),
                                  ),
                                ),
                                items: entry.value
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                value: dropdownSelections[entry.key],
                                onChanged: (val) => dropdownSelections[entry.key] = val,
                              ),
                            )),

                            // Yes/No Questions
                            ...yesNoQuestions.map((q) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(q, style: const TextStyle(color: darkGrey, fontWeight: FontWeight.w600)),
                                  Row(
                                    children: ["Yes", "No"].map((ans) {
                                      return Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(ans, style: const TextStyle(color: fontGrey)),
                                          value: ans,
                                          groupValue: yesNoSelections[q],
                                          activeColor: purpleColor,
                                          onChanged: (val) {
                                            yesNoSelections[q] = val;
                                            (context as Element).markNeedsBuild(); // to refresh UI
                                          },
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            )),

                            const SizedBox(height: 20),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel", style: TextStyle(color: red)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (textControllers.values.any((c) => c.text.trim().isEmpty) ||
                                        dropdownSelections.values.any((v) => v == null) ||
                                        yesNoSelections.values.any((v) => v == null)) {
                                      Get.snackbar("Incomplete", "Please answer all questions.",
                                          backgroundColor: red, colorText: white);
                                      return;
                                    }

                                    final answers = <String, String>{};
                                    answers.addAll(textControllers.map((k, v) => MapEntry(k, v.text.trim())));
                                    answers.addAll(dropdownSelections.map((k, v) => MapEntry(k, v!)));
                                    answers.addAll(yesNoSelections.map((k, v) => MapEntry(k, v!)));

                                    Navigator.pop(context, answers);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: purpleColor,
                                    foregroundColor: white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Continue"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

              if (result != null) {
                await controller.uploadImages(context: context, images: controller.pImages);
                controller.uploadProduct();
                Get.back();
              }
            },
            child: const Text('Save', style: TextStyle(color: white)),
          ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSized(),
              CustomTextField(title: 'Name', hintText: 'Product Name', controller: controller.nameController),
              CustomSized(),
              CustomTextField(title: 'Description', hintText: 'Product Description', controller: controller.descriptionController,isDescription: true,),
              CustomSized(),
              CustomTextField(title: 'Price', hintText: 'Product Price', controller: controller.priceController,keyboard: TextInputType.number,),
              CustomSized(),
              CustomTextField(title: 'Quantity', hintText: 'Product Quantity', controller: controller.quantityController,keyboard: TextInputType.number,),
              CustomSized(),
              ProductDropDown(
                title: 'Categories',
                list: controller.categoryList,
                dropValue: controller.categoryValue,
                controller: controller,
              ),
              CustomSized(),
              ProductDropDown(
                title: 'Sub Categories',
                list: controller.subCategoryList,
                dropValue: controller.subCategoryValue,
                controller: controller,
              ),

              CustomSized(),
              smallText(title: 'First image is your display image that buyer see',color: darkGrey),
              CustomSized(),
              Obx(
                  () => controller.pImages.isEmpty ? InkWell(
                      onTap: (){
                        controller.pickMultipleImages(context: context);
                      },
                      child: Container(height: 150,width: 150,child: Icon(Icons.image,size: 35,),)) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:List.generate(controller.pImages.length, (index){
                  return InkWell(
                      onTap: (){
                        controller.pickMultipleImages(context: context);
                      },
                      child: Container(height: 150,width: 150,child: Image.file(controller.pImages[index],fit: BoxFit.fill,),));
                }) ,
              ),
            ),
            CustomSized(),
              smallText(title: 'Select Colors',color: darkGrey),
              CustomSized(),
              Obx(
                ()=> Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(15, (index){
                    return InkWell(
                      onTap: (){
                        controller.selectedIndex(index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(2),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Vx.randomPrimaryColor,
                        ),
                        child: controller.selectedColorIndex.value == index ?Icon(Icons.check_circle,color: white,size: 30,) : null,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
