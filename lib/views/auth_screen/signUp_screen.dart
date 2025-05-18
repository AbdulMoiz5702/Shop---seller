import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/auth_controller.dart';
import 'package:emart_seller/views/widgets_common/customSized.dart';
import 'package:emart_seller/views/widgets_common/custom_button.dart';
import 'package:emart_seller/views/widgets_common/customtextField.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    var nameController = TextEditingController();
    var passwordController = TextEditingController();
    var emailController = TextEditingController();
    return Scaffold(
      backgroundColor: purpleColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSized(height: 0.1,),
              normalText(title: 'Hi Welcome'),
              CustomSized(height: 0.04,),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(appLogo,fit: BoxFit.contain),
                  ),
                  CustomSized(),
                  normalText(title: 'Login as Seller'),
                ],
              ),
              CustomSized(height: 0.04,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      CustomTextField(title: "Name", hintText: 'name', controller: nameController),
                      CustomSized(),
                      CustomTextField(title: "Email", hintText: 'email@gamil.com', controller: emailController),
                      CustomSized(),
                      CustomTextField(title: "Password", hintText: 'password', controller: passwordController),
                      CustomSized(),
                      Obx(
                          ()=> controller.isLoading.value == true ? Center(child: CupertinoActivityIndicator(),) : CustomButton(onTap: (){
                          controller.signup(email: emailController.text.trim(), password: passwordController.text.trim(), context: context, name: nameController.text.trim());
                        }, title: "Login"),
                      ),
                      CustomSized(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          smallText(
                              title: 'Already have an account ?  ',
                              color: purpleColor,
                          ),
                          InkWell(
                              onTap: () {
                                Get.to(()=> LoginScreen(),transition: Transition.cupertino);
                              },
                              child: smallText(
                                  title: 'Login',color: purpleColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomSized(height: 0.3,),
              Center(child: smallText(title: credit,color: white)),
              CustomSized(),

            ],
          ),
        ),
      ),
    );
  }
}
