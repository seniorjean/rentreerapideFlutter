import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as HTTP;
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/sweetAlert.dart';
import '../screens/main/main_page.dart';

//=============production url============================
// final String  base_url = 'https://rentreerapide.com/';
// ======================================================

//===============local & testing url================================
final String base_url     = 'http://192.168.137.1/rentreerapide/';
// final String base_url     = 'http://192.168.1.16/rentreerapide/';
//===================================================================
final String api_base_url = base_url+'api/v1/';


Future<bool> checkConnectivity() async{
  try {
    var response = await HTTP.get(get_api_url('auth/test'));
    // print('connected');
    return response.statusCode == 200;
  } catch (_) {
    // print('not connected ${_}');
    return false;
  }
}

class NoInternetPage extends StatefulWidget {
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Icon(Icons.wifi_off , size: 150,)),
            SizedBox(height: 9.0,),
            Text('imposible de se connecter au serveur'),
            Text('Verifier votre connexion internet ...'),
            SizedBox(height: 6.3,),
            (isLoading)?Center(child: CircularProgressIndicator(),) : MaterialButton(
              color: Colors.red,
              onPressed: ()async{
                setState(() {
                  isLoading = true;
                });
                bool result = await checkConnectivity();
                if(result){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
                }
                else{
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: Text('Reesayer'  ,style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}


void go_to(BuildContext context , Widget page){
  // Navigator.of(context).pop();
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

String get_api_url(String route){
  return api_base_url+''+route;
}

String getProductImageUrl(String image_name,{bool thumb = true}){
  String thumbnail = (thumb)?'thumbs/':'';
  return base_url+'assets/uploads/'+thumbnail+image_name;
}

String format_money(String amount){
  if(!amount.contains('.0000')){
    amount = amount+'.0000';
  }
  amount = amount.replaceFirst('.0000' ,'');
  if(amount.length >= 4 && amount.length<=6 && !amount.contains(',')){
    amount = amount.replaceRange((amount.length-3), (amount.length-3), ',');
  }
  return amount+' FCFA';
}

String cleanMoneyFormat(String amount){
  if(amount.contains('FCFA')){
    amount =  amount.replaceFirst('FCFA' ,'');
  }

  return amount;
}

String cleanDecimalFormat(String amount){
  if(amount.contains('.0000')){
    amount =  amount.replaceFirst('.0000' ,'');
  }

  return amount;
}

String getSlideImageUrl(String image_name){
  return base_url+'assets/uploads/slides/'+image_name;
}

int rand(int min, int max){
  final random = new Random();
  return min + random.nextInt(max - min);
}

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

class INPUT extends StatelessWidget {
  final String title;
  IconData icon;
  bool isPassword = false;
  final TextEditingController controller;
  TextInputType input_type = TextInputType.text;
  double border_radius;

  INPUT(this.title , this.controller , {this.icon , this.input_type , this.border_radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              obscureText: this.isPassword,
              controller: this.controller,
              keyboardType: input_type,
              autocorrect: true,
              decoration: InputDecoration(
                  hintText: title,
                  prefixIcon: Icon(this.icon),
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
}

String randomPromoPrice(String pprice){
  int percentage = rand(30, 60);
  double originalPrice = double.parse(pprice);

  double price_add = (double.parse(pprice) * percentage) / 100;
  double promoPrice = originalPrice + price_add;
  // print('rpercent : ${percentage} --- original : ${pprice} , promo : ${promoPrice}');

  return promoPrice.toString();
  // print('random : ${percentage}');
  // return pprice;
}

String getDiscount(String price , String promoPrice){

  double p  = double.tryParse(price);
  double pp = double.tryParse(promoPrice);
  if(p != null && pp != null){
    var discount_percentage = ((pp * 100) / p) - 100;
    return discount_percentage.round().toString();
  }
  else{
   // print('price : ${price} ----- promo : ${promoPrice}');
  return 'xx';
  }

}

String getPercentage(String price , String paid){

  double p  = double.tryParse(price);
  double pp = double.tryParse(paid);
  if(p != null && pp != null){
    var discount_percentage = ((pp * 100) / p);
    return discount_percentage.round().toString();
  }
  else{
    // print('price : ${price} ----- promo : ${promoPrice}');
    return 'xx';
  }

}

showMessage(String type , String message){
  Color color = Colors.green;
  String icon = '✔';
  switch(type){
    case 'success':color = Colors.green;  icon = '✔'; break;
    case 'error'  :color = Colors.red;    icon = '❌'; break;
    case 'info'   :color = Colors.blue;   icon = 'ℹ'; break;
    case 'warning':color = Colors.orange; icon = '⚠'; break;
  }


  Fluttertoast.showToast(
      msg: "${icon} ${message}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<bool> validateToken() async {
  String token = '';
  bool token_exist = false;
  if(appDataBox.containsKey('token')){
    token = appDataBox.get('token');
    token_exist = true;
  }
  var response = await HTTP.post(get_api_url('auth/validateToken') , body: {
    'token':token
  });
  var responseJson = jsonDecode(response.body);

  // print(responseJson);

  if(responseJson['status'] == true){
    return true;
  }
  else{
    appDataBox.delete('is_logged_in');
    if(token_exist) appDataBox.delete('token');
    return false;
  }

}


var langs =  {
  'packing'                           : 'Emballage',
  'delivering'                        : 'Livrer',
  'delivered'                         : 'Livré',
  'pending'                           : 'En attente',
  'completed'                         : 'Terminé',
  'verifying'                         : 'Vérification',
  'paid'                              : 'Payé',
  'due'                               : 'Dû',
  'overdue'                           : 'En retard',
  'partial'                           : 'Partiel'
};
String lang(String key){
  if(langs.containsKey(key)){
    return langs[key];
  }
  else{
    return key.replaceAll('_', ' ');
  }
}
