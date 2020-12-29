import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/helpers/sweetAlert.dart';
import 'package:rentreerapide/models/cart.dart';
import 'file:///C:/Users/john/AndroidStudioProjects/rentreerapide/lib/screens/order/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:rentreerapide/models/address.dart';

List<Address> addresses = [];
TextEditingController line1 = TextEditingController(text: '');
TextEditingController line2 = TextEditingController(text: '');
TextEditingController city = TextEditingController(text: '');
TextEditingController state = TextEditingController(text: '');
TextEditingController phone = TextEditingController(text: '');
TextEditingController note = TextEditingController(text: '');
enum paymentMethods {onetime , installment}
var selectedRegion;
var selectedCity;
var saveAddress;

String selectedAddress;
String selectedPaymentMethod = 'onetime';
resetFields(){
  line1 = TextEditingController(text: '');
  line2 = TextEditingController(text: '');
  city = TextEditingController(text: '');
  state = TextEditingController(text: '');
  phone = TextEditingController(text: '');
  selectedRegion = null;
  selectedCity = null;
}

class AddAddressPage extends StatefulWidget {
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}
class _AddAddressPageState extends State<AddAddressPage> {

  _AddAddressPageState(){
    getAddresses().then((data) => setState((){
      addresses = data;
    }));
  }
  paymentMethods selectedPayment = paymentMethods.onetime;

  Cart cart = Cart.fromJson(jsonDecode(appDataBox.get('cart')));
  String shippingFees = '';
  String totalFinal = '';

  saveAddress()async{
    showLoader(context);
    dynamic response = await addAddress(
        region_id: selectedRegion,
        city: selectedCity,
        line1: line1.text,
        line2: line2.text,
        phone: phone.text);

    hideLoader(context);
    bool result = response['status'];
    if (result == true) {
      setState(() {
        addresses = response['addresses'];
        Navigator.of(context).pop();
      });
    }
  }

  addAddressAction(){
    if(addresses != null){
      if(addresses.length<6){
        return () {
          resetFields() ;
          addAddressDialog(context, content: AddAddressForm(), onSaved: saveAddress);
        };
      }
      else{
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget finishButton = MaterialButton(
      onPressed:(selectedAddress == null || shippingFees == '') ? null : (){
          showLoader(context);
          saveOrder(address_id: selectedAddress , comment: note.text , payment_method:selectedPaymentMethod ).then((data)=>setState((){
          hideLoader(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrdersPage()));
        }));
      },
      disabledColor: Color.fromRGBO(226,37,41,0.7),
      color: Colors.red,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Center(
          child: Text("Soumetre la commande",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        title: Text(
          'Selectionnez une Addresse',
          style: const TextStyle(
              color: darkGrey,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
              fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 9.0,
                  right: 9.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Addresse de livraison'),
                  Container(
                    height: (MediaQuery.of(context).size.height * 33) / 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Card(
                            margin: EdgeInsets.all(9.0),
                            color: Colors.white,
                            elevation: 3,
                            child: MaterialButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: addAddressAction(),
                              disabledColor:
                                  Color.fromRGBO(227, 227, 227, 0.63),
                              child: Container(
                                padding: EdgeInsets.all(18.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/icons/address_home.png',
                                      color: darkGrey,
                                    ),
                                    Text(
                                      'Ajouter \nune Addresse',
                                      style: TextStyle(
                                          color: darkGrey,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            )),
                        ...addresses
                            .map((addr) => Row(
                          children: [
                            SizedBox(width:6.3),
                            MaterialButton(
                              onPressed: (){
                                setState(() {
                                  selectedAddress = '${addr.id}';
                                  shippingFees = '${addr.shipping_fee}';
                                  totalFinal = '${int.tryParse(cart.total_amount) + int.tryParse(shippingFees)}';
                                });
                              },
                              color: (selectedAddress == '${addr.id}')?Colors.white:Colors.white70,
                              elevation:(selectedAddress == '${addr.id}')?5.0:1.0,
                              child: Container(
                                  constraints: BoxConstraints(
                                      minWidth: 150.3, maxWidth: 200.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(
                                            children: [
                                              Image.asset('assets/icons/address_home.png', color: darkGrey,),
                                              Padding(
                                                padding: const EdgeInsets.only(top:3.0,left: 3.0),
                                                child: Image.asset('assets/icons/truck.png',),
                                              ),
                                              Expanded(
                                                  child: Text('${format_money('${addr.shipping_fee}')}',
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(color: Colors.orange , fontWeight: FontWeight.bold),
                                                  )
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.home,
                                            ),
                                            SizedBox(width: 3.6),
                                            Text(
                                              '${addr.line1}',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.home,
                                            ),
                                            SizedBox(width: 3.6),
                                            Text(
                                              '${addr.line2}',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                            ),
                                            SizedBox(width: 3.6),
                                            Text(
                                              '${addr.regions_name}',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_pin_circle_sharp,
                                            ),
                                            SizedBox(width: 3.6),
                                            Text(
                                              '${addr.city}',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                            ),
                                            SizedBox(width: 3.6),
                                            Text(
                                              '${addr.phone}',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ))
                            .toList()
                      ],
                    ),
                  ),

                  Divider(),
                  Text('Mode de paiement'),
                  Container(
                    // color: Color(0xff4b943f),
                    constraints: BoxConstraints(
                        minHeight: (MediaQuery.of(context).size.height * 36) / 100),
                    child: Column(
                      children: [
                        Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Radio(
                                      value: paymentMethods.onetime,
                                      groupValue: selectedPayment,
                                      onChanged: (paymentMethods value) {
                                        setState(() {
                                          selectedPayment = value;
                                          selectedPaymentMethod = 'onetime';
                                        });
                                      },
                                    ),
                                    Text('Espece'),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    Radio(
                                      value: paymentMethods.installment,
                                      groupValue: selectedPayment,
                                      onChanged: (paymentMethods value) {
                                        setState(() {
                                          selectedPayment = value;
                                          selectedPaymentMethod = 'installment';
                                        });
                                      },
                                    ),
                                    Text('Versement'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Text('Details'),
                        Card(
                          child: Column(
                            children: [
                              Container(
                                height: 30.0,
                                child: ListTile(
                                  leading: Text('Total'),
                                  trailing: Text(format_money('${cart.total_amount}')),
                                ),
                              ),

                              Container(
                                height: 30.0,
                                child: ListTile(
                                  leading: Text('Livraison'),
                                  trailing: Text('${format_money(shippingFees)}'),
                                ),
                              ),

                              Container(
                                height: 50.0,
                                child: ListTile(
                                  leading: Text('Somme finale'),
                                  trailing: Text('${format_money(totalFinal)}', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.orange),),
                                ),
                              ),


                            ],
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left : 9.0 , right:9.0),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Commentaire'),
                                Container(
                                    margin: EdgeInsets.symmetric(vertical: 16.0),
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: TextField(
                                      controller: note,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          hintText: 'Dite queleque chose a propos de votre commande ...'),
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      maxLength: 200,
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Divider(),

                  Center(child: finishButton),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class AddAddressForm extends StatefulWidget {
  @override
  _AddAddressFormState createState() => _AddAddressFormState();
}
class _AddAddressFormState extends State<AddAddressForm> {

  List<DropdownMenuItem>regions = [];
  List<DropdownMenuItem>cities  = [];
  Color inputBackground = Color(0xfff7f7f7);
  TextStyle inputStyle = TextStyle();
  double inputHeight = 50.4;
  getRegionCities(String region_id)async{
    var data = await getCities(region_id);
    bool slc = false;
    setState((){
      cities = [];
      data.forEach((element) {
        DropdownMenuItem i = DropdownMenuItem(
          child: Text('${element.city_name}'),
          value: '${element.city_name}',
        );
        cities.add(i);

        if(!slc){
          selectedCity = element.city_name;
          slc = true;
        }
      });
    });
  }

  InputDecoration _inputDecoration(String label){
    return InputDecoration(
      labelText: "${label}",
      labelStyle: TextStyle(color: Colors.orange,),
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange)),

    );
  }

  Widget _input(TextEditingController controller , label , {TextInputType type = TextInputType.text}){
    return  Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
      height: inputHeight,
      child: TextField(
        controller: controller,
        decoration: _inputDecoration('${label}'),

      ),
    );
  }

  _AddAddressFormState(){
    getRegions().then((data)=>setState((){
      regions = [];
      data.forEach((element) {
        DropdownMenuItem i = DropdownMenuItem(
          child: Text('${element.region_name}'),
          value: '${element.id}',
        );
        regions.add(i);
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: inputHeight+9,
            padding: EdgeInsets.all(0.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: inputBackground,),
            child: DropdownButtonFormField(
                value: selectedRegion,
                dropdownColor: Colors.white,
                items: regions,
                decoration: _inputDecoration('Region'),
                style: TextStyle(color: Colors.black),
                onChanged: (value)async{
                  showLoader(context,title: 'Chargement des villes');
                  setState(() {
                    selectedRegion = value;
                  });
                  await getRegionCities(value);
                  hideLoader(context);
                }),
          ),
          SizedBox(height: 6.3),
          Container(
            height: inputHeight+9,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),),
            child: DropdownButtonFormField(
                value: selectedCity,
                dropdownColor: Colors.white,
                decoration: _inputDecoration('Ville'),
                items: cities,
                style: TextStyle(color: Colors.black),
                onChanged: (value){
                  setState(() {
                    selectedCity = value;
                  });
                }),
          ),
          SizedBox(height: 6.3),
          _input(line1, 'Addresse'),
          SizedBox(height: 6.3,),
         _input(line2, 'Information Supplementaire'),

          SizedBox(height: 6.3,),
          _input(phone, 'Telephone' ,  type: TextInputType.phone),
        ],
      ),
    );
  }
}