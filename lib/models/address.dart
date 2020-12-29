import 'package:http/http.dart' as HTTP;
import 'package:rentreerapide/helpers/consts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/helpers/sweetAlert.dart';

class Address{
  String id , company_id , line1 , line2 , city, region_id, regions_name , phone;
  int shipping_fee;

  Address({this.id, this.company_id, this.line1, this.line2, this.city,
      this.region_id, this.regions_name, this.phone , this.shipping_fee});

  factory Address.fromJson(dynamic json){
    return Address(
      id: json['id'],
      company_id: json['company_id'],
      city: json['city'],
      line1: json['line1'],
      line2: json['line2'],
      phone: json['phone'],
      region_id: json['region_id'],
      regions_name: json['region_name'],
      shipping_fee: int.tryParse(json['shipping_fee']),
    );
  }
}

class Region{
  String id , region_name, description;
  Region({this.id , this.region_name , this.description});

  factory Region.fromJson(dynamic json){
    return Region(
      id: json['id'],
      region_name: json['region_name'],
      description: json['description']
    );
  }

}


class City{
  String id , city_name, description;
  City({this.id , this.city_name , this.description});
  factory City.fromJson(dynamic json){
    return City(
        id: json['id'],
        city_name: json['region_name'],
        description: json['description']
    );
  }

}

Future<List<Address>> getAddresses() async{
  var response = await HTTP.post(get_api_url('cart/getShippingFees'),body: {
    'token':'${appDataBox.get('token')}',
  });
  var responseJson = jsonDecode(response.body);
  // print(responseJson);
  List<Address> addrs = [];
  for(var addr in responseJson){
    addrs.add(Address.fromJson(addr));
  }
  return addrs;
}

Future<List<Region>> getRegions()async{
  var response = await HTTP.get(get_api_url('shop/getRegions'));
  var responseJson = jsonDecode(response.body);
  List<Region> rgs = [];
  for(var r in responseJson){
    rgs.add(Region.fromJson(r));
  }
  return rgs;
}

Future<List<City>> getCities(String region_id)async{
  var response = await HTTP.get(get_api_url('shop/getCities/${region_id}'));
  var responseJson = jsonDecode(response.body);
  if(responseJson['status']== true){
    List<City> ctys = [];
    for(var c in responseJson['cities']){
      ctys.add(City.fromJson(c));
    }
    return ctys;
  }
  return [];
}

Future<dynamic> addAddress({String line1 , String line2 , String city , String region_id , String phone})async{
  var response = await HTTP.post(get_api_url('shop/address') , body: {
    'token':appDataBox.get('token'),
    'line1':'${line1}',
    'line2':'${line2}',
    'city':'${city}',
    'state':'${region_id}',
    'phone':'${phone}',
  });

  var responseJson = jsonDecode(response.body);
  // print(responseJson);
  if(responseJson['status'] == true){
    showMessage('success', responseJson['message']);
    List<Address> addr = [];
    for(var ad in responseJson['addresses']){
      addr.add(Address.fromJson(ad));
    }
    return {
      'status':true,
      'addresses':addr,
    };
  }
  else{
    showMessage('error', 'Veillez remplir le formulaire');
    return {
      'status':false
    };
  }
}