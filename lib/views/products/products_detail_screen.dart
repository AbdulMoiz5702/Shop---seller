import 'package:emart_seller/const/const.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets_common/customSized.dart';
import '../widgets_common/test_widgets.dart';


class ProductDetailsScreen extends StatelessWidget {
  final dynamic data ;
  const ProductDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
                enlargeCenterPage: true,
                scrollPhysics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                autoPlayCurve: Curves.easeInOutExpo,
                autoPlay: true,
                aspectRatio: 10 / 8,
                isFastScrollingEnabled: true,
                itemCount: data['p_images'].length,
                itemBuilder: (context, index) {
                  var images = data['p_images'][index];
                  return Container(
                    margin: EdgeInsets.all(5),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(images),
                          fit: BoxFit.fill,
                          isAntiAlias: true),
                    ),
                  );
                }),
            CustomSized(),
            CustomSized(height: 0.01),
            VxRating(
              isSelectable: false,
              value: 3,
              onRatingUpdate: (value) {},
              normalColor: textfieldGrey,
              count: 5,
              selectionColor: golden,
              maxRating: 5,
              size: 25,
            ),
            CustomSized(),
            normalText(title: data['p_name'], color: purpleColor),
            CustomSized(),
            normalText(title: '${data['p_price']} \$', color: purpleColor),
            CustomSized(),
            normalText(title: 'Category : ${data['p_category']}', color: purpleColor),
            CustomSized(),
            normalText(title: 'Subcategory : ${data['p_subcategory']}', color: purpleColor),
            CustomSized(),
            CustomSized(),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        smallText(
                          title: 'Quantity :',
                          color: darkGrey,
                        ),
                        CustomSized(),
                        smallText(
                          title: data['p_quantity'],
                          color: darkGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomSized(),
            normalText(title: 'Description', color: darkGrey),
            CustomSized(),
            CustomSized(
              width: 0.06,
              height: 0.01,
            ),
            smallText(title: "${data['p_description']}", color: darkGrey),
            CustomSized(),

          ],
        ),
      ),
    );
  }
}
