import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as HTTP;
import 'package:rentreerapide/screens/main/main_page.dart';
import 'dart:async';
import 'dart:convert';
import 'register_page.dart';


class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}


class _WelcomeBackPageState extends State<WelcomeBackPage> {
  //input controllers
  TextEditingController email = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');

  //widgets
  Widget error_msg = Container();
  Widget errorWidget({show = false , message = '' , type = 'error'}){
    Icon i;
    Color c;
    switch(type){
      case 'error'  : i = Icon(Icons.error_outline , color: Colors.red); c = Colors.red; break;
      case 'success': i = Icon(Icons.check , color: Colors.green); c = Colors.green; break;
      default : i = Icon(Icons.error_outline , color: Colors.red); c = Colors.red; break;
    }
    return Container(
      width: (show)?MediaQuery.of(context).size.width : 0.0,
      child: Row(
        children: [
          i,
          SizedBox(width: 9.0),
          Text(message, style: TextStyle(color: c))
        ],
      ),
    );
  }

  void login() async{
    String token = '';
    if(appData.containsKey('token')){
      token = appData['token'];
    }
    else{
      token = await getToken();
    }

    var response = await HTTP.post(get_api_url('auth/login') , body:{
      'identity':email.text.trim(),
      'password':password.text.trim(),
      'token':token
    });
    var responseJson = jsonDecode(response.body);

    // print(responseJson);


    if(responseJson['status'] != true){
      if(responseJson['message'].toString().trim() == 'invalid token'){
        token = await getToken();
        login();
      }
      else{
        setState(() {
          error_msg = errorWidget(show: true , message: responseJson['message'].toString());
        });
      }

    }

    else{
      setState(() {
        error_msg = errorWidget(show: true , message: responseJson['message'] , type: 'success');
      });
      appDataBox.put('identity', responseJson['user_data']['identity']);
      appDataBox.put('username', responseJson['user_data']['username']);
      appDataBox.put('first_name', responseJson['user_data']['first_name']);
      appDataBox.put('last_name', responseJson['user_data']['last_name']);
      appDataBox.put('phone', responseJson['user_data']['phone']);
      appDataBox.put('email', responseJson['user_data']['email']);
      appDataBox.put('user_id', responseJson['user_data']['user_id']);
      appDataBox.put('avatar', responseJson['user_data']['avatar']);
      appDataBox.put('gender', responseJson['user_data']['gender']);
      appDataBox.put('group_id', responseJson['user_data']['group_id']);
      appDataBox.put('allow_discount', responseJson['user_data']['allow_discount']);
      appDataBox.put('company_id', responseJson['user_data']['company_id']);
      appDataBox.put('is_logged_in', 'true');


      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));

    }

  }


  Future<String> getToken() async{
    var response = await HTTP.get(get_api_url('auth/getToken'));
    var responseJson = jsonDecode(response.body);

    String tok = '';
    if(responseJson['status'] == true){
      tok =  responseJson['value'];
      appDataBox.put('token',tok);
    }
    return tok;
  }

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'Connectez-vous',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login to your account using\nMobile number',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 9,
      child: InkWell(
        onTap: () {
          setState(() {
            error_msg = CircularProgressIndicator();
          });
          login();
          //Navigator.of(context)
              //.push(MaterialPageRoute(builder: (_) => RegisterPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: Center(
              child: new Text("Log In",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget entryField(String title, icon, {bool isPassword = false , controller , TextInputType input_type = TextInputType.text}) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 3.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
                obscureText: isPassword,
                controller: controller,
                keyboardType: input_type,
                autocorrect: true,
                decoration: InputDecoration(
                    hintText: title,
                    prefixIcon: Icon(icon),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    filled: true)
            ),
          ],
        ),
      );
    }

    Widget loginForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 12.0, right: 12.0,top: 10.0),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.5),
                  child: entryField('Identifiant', Icons.email, controller: email , isPassword: false , input_type: TextInputType.emailAddress),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.5),
                  child: entryField('Mot de passe', Icons.lock, controller: password , isPassword: true , input_type: TextInputType.text),
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: error_msg,
                )
              ],
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Mot de passe oublie ?',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Reiinitialiser',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(

      body: Stack(
        children: <Widget>[

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover)
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black12,),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 1),
                welcomeBack,
                SizedBox(height: 6.0,),
                // subTitle,
                Spacer(flex: 1),
                loginForm,
                Spacer(flex: 2),
                forgotPassword
              ],
            ),
          )
        ],
      ),
    );
  }
}


