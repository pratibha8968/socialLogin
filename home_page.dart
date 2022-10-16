import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';



GoogleSignIn _googleSignIn = GoogleSignIn();
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FacebookLogin facebookSignIn = FacebookLogin();
  Future<dynamic> _login() async{
    _logOut();

    final result = await facebookSignIn.logIn(customPermissions: ['email']);
    print('result');
    var status = {FacebookLoginStatus};FacebookLoginStatus.error; final token = result.accessToken?.token;
    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?feilds=name,picture,email&acess_token='));
    final profile = json.decode(graphResponse.body);
    print('profile');
  }
  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
  }


  @override
  void initState(){
    super.initState();
  }

  @override
  dispose (){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child: SizedBox(height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    googleSignInProcess(context);
                    },
                    child: Text("Login with gmail"),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(onPressed: (){
                    _login();



                  },

                    child: Text("Login with facebook"),
                  ),

                ],
              ),



            ),
          ),




        ),

      ),
    );
  }

  void googleSignInProcess(BuildContext context) async {
    if(await _googleSignIn.isSignedIn()){
      handleSignOut();

    }
    GoogleSignInAccount? googleUser;
    GoogleSignInAuthentication googleSignInAuthentication;
    try {
      googleUser = (await _googleSignIn.signIn());
      if (googleUser!= null ){
        googleSignInAuthentication = await googleUser.authentication;
        print(googleSignInAuthentication.accessToken);
      }
    } catch (error) {
      print(error);
    }
    if (await _googleSignIn.isSignedIn()){

      print(googleUser?.email);
      print(googleUser?.displayName);
      print(googleUser?.photoUrl);
      print(googleUser?.id);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("sucess : ${googleUser?.email}" ?? "")));


    }
  }
  Future<void>handleSignOut() => _googleSignIn.disconnect();

}




