
import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/material.dart';

import 'customSized.dart';




class OrderDetails extends StatelessWidget {
  final String title ;
  final IconData icon ;
  final IconData ? lastIcon ;
  final Color color ;
  const OrderDetails({required this.title,required this.color,required this.icon,required this.lastIcon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,color: color,),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          smallText(title: title,color: purpleColor,),
          CustomSized(),
          Icon(lastIcon,color: color,),
        ],
      ),
    );
  }
}
