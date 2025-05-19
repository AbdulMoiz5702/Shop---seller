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
          Obx(
                () => controller.isLoading.value
                ? const Center(child: CupertinoActivityIndicator())
                : TextButton(
              onPressed: () {
                _showQuestionBottomSheet(context, controller);
              },
              child: const Text('Save', style: TextStyle(color: white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSized(),
              CustomTextField(
                  title: 'Name',
                  hintText: 'Product Name',
                  controller: controller.nameController),
              CustomSized(),
              CustomTextField(
                title: 'Description',
                hintText: 'Product Description',
                controller: controller.descriptionController,
                isDescription: true,
              ),
              CustomSized(),
              CustomTextField(
                title: 'Price',
                hintText: 'Product Price',
                controller: controller.priceController,
                keyboard: TextInputType.number,
              ),
              CustomSized(),
              CustomTextField(
                title: 'Quantity',
                hintText: 'Product Quantity',
                controller: controller.quantityController,
                keyboard: TextInputType.number,
              ),
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
              smallText(
                  title: 'First image is your display image that buyer see',
                  color: darkGrey),
              CustomSized(),
              Obx(
                    () => controller.pImages.isEmpty
                    ? InkWell(
                  onTap: () {
                    controller.pickMultipleImages(context: context);
                  },
                  child: const SizedBox(
                      height: 150,
                      width: 150,
                      child: Icon(Icons.image, size: 35)),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(controller.pImages.length,
                          (index) {
                        return InkWell(
                          onTap: () {
                            controller.pickMultipleImages(context: context);
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            child: Image.file(
                              controller.pImages[index],
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                ),
              ),
              CustomSized(),
              smallText(title: 'Select Colors', color: darkGrey),
              CustomSized(),
              Obx(
                    () => Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(15, (index) {
                    return InkWell(
                      onTap: () {
                        controller.selectedIndex(index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Vx.randomPrimaryColor,
                        ),
                        child: controller.selectedColorIndex.value == index
                            ? const Icon(Icons.check_circle,
                            color: white, size: 30)
                            : null,
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

  void _showQuestionBottomSheet(
      BuildContext context, ProductController controller) {
    // Controllers for text fields
    final uniquenessController = TextEditingController();
    final notesController = TextEditingController();

    // Reactive variables for radio answers
    final handmadeOrVintage = ''.obs; // values: 'Handmade', 'Vintage'
    final limitedEdition = ''.obs; // values: 'Yes', 'No'

    showModalBottomSheet(
      context: context,
      backgroundColor: white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please answer the following before saving:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: purpleColor),
                ),
                const SizedBox(height: 20),

                // Question 1: Radio buttons for Handmade or Vintage
                Text("Is this item Handmade or Vintage?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: fontGrey)),
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Handmade',style: TextStyle(fontSize: 10),),
                        value: 'Handmade',
                        groupValue: handmadeOrVintage.value,
                        onChanged: (val) {
                          handmadeOrVintage.value = val!;
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Vintage',style: TextStyle(fontSize: 10)),
                        value: 'Vintage',
                        groupValue: handmadeOrVintage.value,
                        onChanged: (val) {
                          handmadeOrVintage.value = val!;
                        },
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 16),

                // Question 2: TextField for uniqueness
                Text("Describe the uniqueness of your product",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: fontGrey)),
                const SizedBox(height: 8),
                TextField(
                  controller: uniquenessController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Write something special about your item...",
                  ),
                ),
                const SizedBox(height: 16),

                // Question 3: Radio buttons for Limited Edition
                Text("Is this a limited edition?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: fontGrey)),
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Yes'),
                        value: 'Yes',
                        groupValue: limitedEdition.value,
                        onChanged: (val) {
                          limitedEdition.value = val!;
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('No'),
                        value: 'No',
                        groupValue: limitedEdition.value,
                        onChanged: (val) {
                          limitedEdition.value = val!;
                        },
                      ),
                    ),
                  ],
                )),
                const SizedBox(height: 16),

                // Question 4: TextField for additional notes
                Text("Any additional notes?",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: fontGrey)),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: lightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Write additional notes if any...",
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Validation
                      if (handmadeOrVintage.value.isEmpty) {
                        Get.snackbar("Error", "Please select Handmade or Vintage",
                            backgroundColor: red, colorText: white);
                        return;
                      }
                      if (uniquenessController.text.trim().isEmpty) {
                        Get.snackbar(
                            "Error", "Please describe uniqueness",
                            backgroundColor: red, colorText: white);
                        return;
                      }
                      if (limitedEdition.value.isEmpty) {
                        Get.snackbar("Error", "Please select Limited Edition option",
                            backgroundColor: red, colorText: white);
                        return;
                      }

                      // You can save these answers to the controller if needed:
                      controller.handmadeOrVintage.value = handmadeOrVintage.value;
                      controller.uniqueness.value = uniquenessController.text.trim();
                      controller.limitedEdition.value = limitedEdition.value;
                      controller.additionalNotes.value = notesController.text.trim();
                      Navigator.of(context).pop(); // Close BottomSheet
                      // Then upload
                      controller.uploadImages(context: context, images: controller.pImages).then((value){
                        controller.uploadProduct();
                        Get.back();
                      });

                    },
                    child: const Text("Submit", style: TextStyle(color: white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

