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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        },
        child: Icon(Icons.add),
      ),
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
                  return Container(
                    margin: EdgeInsets.all(5),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage(appLogo),
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
            Row(
              children: [
                normalText(title: 'Category : ${data['p_category']}', color: purpleColor),
                CustomSized(),
                normalText(title: 'Subcategory : ${data['p_subcategory']}', color: purpleColor),
              ],
            ),
            CustomSized(),
            Card(
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.sizeOf(context).width * 1,
                    height: MediaQuery.sizeOf(context).height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        smallText(title: 'Colors', color: textfieldGrey),
                        CustomSized(),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                                 data['p_colors'].length,
                                    (index) {
                                  return InkWell(
                                    onTap: () {
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(2),
                                      height: 100,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: data['p_colors'][index]),
                                      ));
                                })),
                      ],
                    )),
              ),
            ),
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
                          title: data['65'],
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
