import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/views/auth_screen/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import '../const/const.dart';
import '../const/fire_base_constants.dart';
import '../views/home/home.dart';


class AuthController extends GetxController {

  var isLoading = false.obs;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final LocalAuthentication authLocal = LocalAuthentication();

  Future<void> saveCredentials(String email, String password) async {
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
    print('Credentials saved: $email, $password'); // Debug statement
  }


  Future<bool> authenticateWithBiometrics() async {
    try {
      bool authenticated = await authLocal.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, String>> getCredentials() async {
    String? email = await secureStorage.read(key: 'email');
    String? password = await secureStorage.read(key: 'password');
    print('Retrieved credentials: $email, $password'); // Debug statement

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return {};
  }


  Future<void> loginWithStoredCredentials(BuildContext context) async {
    bool authenticated = await authenticateWithBiometrics();
    print('Biometric authentication result: $authenticated'); // Debug statement

    if (authenticated) {
      Map<String, String> credentials = await getCredentials();
      print('Stored credentials: $credentials'); // Debug statement

      if (credentials.isNotEmpty) {
        try {
          final UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: credentials['email']!,
            password: credentials['password']!,
          );
          final User? user = userCredential.user;

          if (user != null) {
            print('User logged in successfully: ${user.uid}'); // Debug statement
            isLoading(false);
            Get.to(() => Home(), transition: Transition.cupertino);
          } else {
            print('User is null'); // Debug statement
          }
        } catch (e) {
          print('Error signing in with stored credentials: $e'); // Debug statement
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error signing in with stored credentials')));
        }
      } else {
        print('Stored credentials are empty'); // Debug statement
      }
    } else {
      print('Biometric authentication failed'); // Debug statement
    }
  }

  Future<UserCredential?> login({required String email ,required String password,required BuildContext context}) async{
    UserCredential ? userCredential ;
    try{
      isLoading(true);
      auth.signInWithEmailAndPassword(email: email, password: password).then((value)async {
        await saveCredentials(email, password);
        isLoading(false);
        VxToast.show(context, msg: 'Login successfully');
        Get.offAll(()=> Home(),transition: Transition.cupertino);
      });
    }catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
    return userCredential ;
  }

  Future<UserCredential?> signup({required String email ,required String password,required BuildContext context,required String name}) async{
    UserCredential ? userCredential ;
    try{
      isLoading(true);
      auth.createUserWithEmailAndPassword(email: email, password: password).then((value) async {
       await saveCredentials(email, password);
        await storeUserdata(name, password, email,);
        VxToast.show(context, msg: 'Account Created successfully');
        isLoading(false);
        Get.offAll(()=>const Home());
      });
    }catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
    return userCredential ;
  }

  Future<UserCredential?> forgotPassword({required String email ,required BuildContext context}) async{
    UserCredential ? userCredential ;
    try{
      isLoading(true);
      auth.sendPasswordResetEmail(email: email,);
    }on FirebaseAuthException catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
    return userCredential ;
  }

  Future logout({required BuildContext context}) async{
    try{
      isLoading(true);
      await auth.signOut();
      Get.offAll(()=> const LoginScreen(),transition: Transition.cupertino);
      isLoading= false.obs;
    }on FirebaseAuthException catch(e){
      isLoading(false);
      VxToast.show(context, msg: e.toString());
    }
  }

  // store user data

  storeUserdata(name,password,email) async {
    DocumentReference store =  fireStore.collection(vendorCollection).doc(currentUser!.uid);
    await store.set({
      'name':name,
      'password':password,
      'email':email,
      'imageUrl':'none',
      'id':currentUser!.uid,
      'shop_name':'',
      'shop_address': '',
      'shop_mobile':'',
      'shop_website': '',
      'shop_description': '',
    });
  }




}