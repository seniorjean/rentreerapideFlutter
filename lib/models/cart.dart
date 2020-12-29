import 'package:http/http.dart' as HTTP;
import 'package:rentreerapide/helpers/consts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:rentreerapide/helpers/mix_helper.dart';

class CartItem{
  String id;
  String product_id;
  String row_id;
  String qty;
  String name;
  String image;
  String big_image;
  String subtotal;
  String price;
  String warehouse_name;
  bool in_wishlist;

  CartItem({this.id = '', this.product_id = '', this.row_id = '', this.qty = '', this.name = '', this.image = '' , this.in_wishlist  , this.big_image, this.subtotal = '', this.price = '' , this.warehouse_name});

  factory CartItem.fromJson(dynamic json){
    return CartItem(
      id: json['id'],
      product_id: json['product_id'],
      row_id: json['rowid'],
      qty: json['qty'].toString(),
      name: json['name'],
      image: getProductImageUrl(json['image'] , thumb: true),
      big_image: getProductImageUrl(json['image'] , thumb: false),
      subtotal: json['subtotal'],
      price: json['price'],
      in_wishlist: json['in_wishlist'],
      warehouse_name: (json['warehouse_name'] != null)?json['warehouse_name'] : ''
    );
  }
}

class Cart{
  String total_items;
  String total_unique_items;
  String total_amount;
  List<CartItem> content;


  Cart({this.total_items, this.total_unique_items, this.total_amount, this.content});

  factory Cart.fromJson(dynamic json){
    return Cart(
        total_items : json['total_items'].toString(),
        total_unique_items : json['total_unique_items'].toString(),
        total_amount : json['total_amount'].toString(),
        content: buildCartItem(json['contents']),
    );
  }
}

List<CartItem> buildCartItem(dynamic json){
  List<CartItem> cit = [];
  json.forEach((element) {
    cit.add(CartItem.fromJson(element));
  });

  return cit;
}

Future<bool> addToCart(String product_id , String qty) async{
  var response = await HTTP.post(get_api_url('cart/add'),body: {
    'token':appDataBox.get('token'),
    'product_id':product_id,
    'quantity':qty
  });

  var responseJson = jsonDecode(response.body);
  // print('-------------------------------------------------------------');
  // print(responseJson);
  // print('-------------------------------------------------------------');
  if(responseJson['status'] == true){
    showMessage('success', responseJson['message']);
    return true;
  }
  else{
    showMessage('error' , responseJson['message']);
    return false;
  }

}

Future<String> emptyCart() async{
  var response = await HTTP.post(get_api_url('cart/emptyCart'),body: {
    'token':appDataBox.get('token'),
  });

  var responseJson = jsonDecode(response.body);
  if(responseJson['status'] == true){
    showMessage('success', responseJson['message']);
  }
  else{
    showMessage('error' , responseJson['message']);
  }
  return responseJson['message'];
}

Future<bool> addToWishlist(String product_id) async{
  var response = await HTTP.post(get_api_url('cart/addWishlist'),body: {
    'token':appDataBox.get('token'),
    'product_id':product_id,
  });

  var responseJson = jsonDecode(response.body);
  if(responseJson['status'] == true){
    showMessage('success', responseJson['message']);
    return true;
  }
  else{
    showMessage('error' , responseJson['message']);
    return false;
  }
}

Future<dynamic> getCartData() async{
  var response = await HTTP.post(get_api_url('cart/getCartInfo') , body: {
    'token':appDataBox.get('token')
  });
  // print(appDataBox.get('token'));
  var responseJson = jsonDecode(response.body);
  // print(responseJson);
  if(responseJson['status'] == true){
    appDataBox.put('cart' , jsonEncode(responseJson));
    return {
      'status':true,
      'cart':Cart.fromJson(responseJson),
    };
  }
  else{
    appDataBox.delete('cart');
    return {
      'status':false ,
      'message':responseJson['message']
    };
  }
}

Future<dynamic> removeCartItem(String row_id) async{
  // print(row_id);
  var response = await HTTP.post(get_api_url('cart/remove') , body: {
    'token':appDataBox.get('token'),
    'rowid':row_id,
  });

  var responseJson = jsonDecode(response.body);
  if(responseJson['status'] == true){

    appDataBox.put('cart' , jsonEncode(responseJson));

    return {
      'status':true,
      'cart':Cart.fromJson(responseJson),
    };
  }
  else{
    return {
      'status':false ,
      'message':responseJson['message']
    };
  }
}

Future<dynamic> updateCartItem(String row_id , String qty) async{
  var response = await HTTP.post(get_api_url('cart/update') , body: {
    'token':appDataBox.get('token'),
    'rowid':row_id,
    'qty':qty,
  });
  var responseJson = jsonDecode(response.body);
  if(responseJson['status'] == true){
    appDataBox.put('cart' , jsonEncode(responseJson));
    return {
      'status':true,
      'cart':Cart.fromJson(responseJson),
    };
  }
  else{
    showMessage('error',responseJson['message']);
    return {
      'status':false ,
      'message':responseJson['message']
    };
  }
}

Future<dynamic> saveOrder({String address_id , String comment = '' , String payment_method}) async{
  var response = await HTTP.post(get_api_url('shop/order') , body: {
    'token':appDataBox.get('token'),
    'address':address_id,
    'note':comment,
    'payment_method':payment_method
  });
  var responseJson = jsonDecode(response.body);
  // print(responseJson);
  showMessage('success', responseJson['message']);
  if(responseJson['status'] == true){
    appDataBox.delete('cart');
    return {
      'status':true,
      'sale_id':responseJson['sale_id']
    };
  }
  else{
    return {
      'status':false ,
      'message':responseJson['message']
    };
  }
}

