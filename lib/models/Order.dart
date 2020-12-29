import 'dart:typed_data';

import 'package:http/http.dart' as HTTP;
import 'package:rentreerapide/helpers/consts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:rentreerapide/helpers/mix_helper.dart';


class Order{
  String page,installment_orders,onetime_orders,total;
  List<OneTimePayment> onetimePayments;
  List<InstallmentPayment> installmentPayments;


  Order(
      {this.page,
      this.installment_orders,
      this.onetime_orders,
      this.total,
      this.onetimePayments,
      this.installmentPayments});

  factory Order.fromJson(dynamic json){
        return Order(
      page: json['page_info']['page'].toString(),
      installment_orders: json['page_info']['installment_order'].toString(),
      onetime_orders: json['page_info']['onetime_orders'].toString(),
      total: json['page_info']['total'].toString(),
        installmentPayments: installmentPaymentList(json['installment_orders']),
        onetimePayments: onetimePaymentList(json['onetime_orders']),
    );
  }
}

class OneTimePayment{
  String order_id,reference_no,total,shipping, grand_total,paid,sale_status,payment_status, delivery_status ,payment_method;

  OneTimePayment({this.order_id,
      this.reference_no,
      this.total,
      this.shipping,
      this.grand_total,
      this.paid,
      this.sale_status,
      this.payment_status,
      this.delivery_status,
      this.payment_method});

  factory OneTimePayment.fromJson(dynamic json){
    return OneTimePayment(
      order_id : json['order_id'] ,
      reference_no : json['reference_no'] ,
      total : json['total'] ,
      shipping : json['shipping'] ,
      grand_total : json['grand_total'] ,
      paid : json['paid'] ,
      sale_status : lang(json['sale_status']) ,
      payment_status : json['payment_status'] ,
      delivery_status : (json['delivery_status']!=null)? lang(json['delivery_status']) : 'En attente' ,
      payment_method : json['payment_method'] ,
    );
  }
}

class InstallmentPayment{
  String order_id,reference_no,total,shipping, grand_total,paid,sale_status,payment_status, delivery_status ,payment_method;
  String weekly_pay ,num_of_week , installment_fee;
  String w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12;

  InstallmentPayment(
      {this.order_id,
      this.reference_no,
      this.total,
      this.shipping,
      this.grand_total,
      this.paid,
      this.sale_status,
      this.payment_status,
      this.delivery_status,
      this.payment_method,
      this.weekly_pay,
      this.num_of_week,
      this.installment_fee,
      this.w1 = '',
      this.w2 = '',
      this.w3 = '',
      this.w4 = '',
      this.w5 = '',
      this.w6 = '',
      this.w7 = '',
      this.w8 = '',
      this.w9 = '',
      this.w10 = '',
      this.w11 = '',
      this.w12 = ''});
    factory InstallmentPayment.fromJson(dynamic json){
      return InstallmentPayment(
        order_id : json['order_id'].toString() ,
        reference_no : json['reference_no'] ,
        total : json['total'] ,
        shipping : json['shipping'] ,
        grand_total : json['grand_total'] ,
        paid : json['paid'] ,
        sale_status : json['sale_status'] ,
        payment_status : json['payment_status'] ,
        delivery_status : json['delivery_status']??'En attente' ,
        payment_method : json['payment_method'] ,
        installment_fee: '${double.parse(json['grand_total']) - (double.parse(json['total']) + double.parse(json['shipping']))}',
        w1 : (json['w1'] != null)?json['w1'] : '',
        w2 : (json['w2'] != null)?json['w2'] : '',
        w3 : (json['w3'] != null)?json['w3'] : '',
        w4 : (json['w4'] != null)?json['w4'] : '',
        w5 : (json['w5'] != null)?json['w5'] : '',
        w6 : (json['w6'] != null)?json['w6'] : '',
        w7 : (json['w7'] != null)?json['w7'] : '',
        w8 : (json['w8'] != null)?json['w8'] : '',
        w9 : (json['w9'] != null)?json['w9'] : '',
        w10 : (json['w10'] != null)?json['w10'] : '',
        w11 : (json['w11'] != null)?json['w11'] : '',
        w12 : (json['w12'] != null)?json['w12'] : '',
        num_of_week: json['num_of_week'],
        weekly_pay: json['weekly_pay'],
      );
    }


}

List<OneTimePayment> onetimePaymentList(dynamic json){
  List<OneTimePayment> otp = [];
  json.forEach((element){
    otp.add(OneTimePayment.fromJson(element));
  });
  return otp;
}

List<InstallmentPayment> installmentPaymentList(dynamic json){
  List<InstallmentPayment> itp = [];
  json.forEach((element){
    itp.add(InstallmentPayment.fromJson(element));
  });
  return itp;
}

Future<Order> getOrders()async{
  var response = await HTTP.post(get_api_url('shop/getOrders') , body : {
    'token':appDataBox.get('token'),
  });
  var responseJson = jsonDecode(response.body);
  return Order.fromJson(responseJson);
}
//==========================================================================

Future<OrderDetails> getOrderDetails(String order_id)async{
  var response = await HTTP.post(get_api_url('shop/getOrdersById') , body : {
    'token':appDataBox.get('token'),
    'order_id':order_id
  });
  var responseJson = jsonDecode(response.body);
  return OrderDetails.fromJson(responseJson);
}

class OrderDetails{
  String id ,date , balance, notice, reference_no, sale_status,total,product_discount,total_discount,shipping,grand_total,payment_status,total_items,paid,surcharge,payment_method ;
  //biller details
  String company , address , city , state, country,email,phone,invoice_footer,logo;
  //shipping address;
  String shp_company_id,shp_email ,shp_name, shp_line1,shp_line2,shp_city,shp_state,shp_country , shp_phone, shp_region_id;
  List<OrderItem> items;
  // qrcode and barcode
  String barcode;
  Uint8List qrcode;

  OrderDetails(
      {
      this.id,
      this.date,
      this.balance,
      this.notice,
      this.reference_no,
      this.sale_status,
      this.total,
      this.product_discount,
      this.total_discount,
      this.shipping,
      this.grand_total,
      this.payment_status,
      this.total_items,
      this.paid,
      this.surcharge,
      this.payment_method,
      this.company,
      this.address,
      this.city,
      this.state,
      this.country,
      this.email,
      this.phone,
      this.invoice_footer,
      this.logo,
      this.shp_company_id,
      this.shp_line1,
      this.shp_line2,
      this.shp_city,
      this.shp_state,
      this.shp_country,
      this.shp_phone,
      this.shp_email,
      this.shp_name,
      this.shp_region_id,
      this.items,
      this.qrcode,
      this.barcode
      });
      factory OrderDetails.fromJson(dynamic json){
        //print('${base_url}admin/${json['barcode']}');
        return OrderDetails(
            id:json['inv']['id'],
            date : json['inv']['date'],
            notice : json['notice'],
            reference_no : json['inv']['reference_no'],
            sale_status : lang(json['inv']['sale_status']),
            total : format_money(json['inv']['total']),
            product_discount : json['inv']['product_discount'],
            total_discount : json['inv']['total_discount'],
            shipping : json['inv']['shipping'],
            grand_total : format_money(json['inv']['grand_total']),
            payment_status : lang(json['inv']['payment_status']),
            total_items : json['inv']['total_items'],
            paid : format_money(json['inv']['paid']),
            balance: format_money((double.tryParse(json['inv']['grand_total']) - double.tryParse(json['inv']['paid'])).toString()),
            surcharge : json['surcharge'],
            payment_method : json['payment_method'],

            company : json['biller']['company'],
            address : json['biller']['address'],
            city : json['biller']['city'],
            state : json['biller']['state'],
            country : json['biller']['country'],
            email : json['biller']['email'],
            phone : json['biller']['phone'],
            invoice_footer : json['biller']['invoice_footer'],
            logo : json['biller']['logo'],

            shp_company_id : json['company_id'],
            shp_line1 : json['address']['line1'],
            shp_line2 : json['address']['line2'],
            shp_city : json['address']['city'],
            shp_state : json['address']['state'],
            shp_country : json['address']['country'],
            shp_phone : json['address']['phone'],
            shp_region_id : json['address']['region_id'],
            shp_email : json['customer']['email'],
            shp_name : json['customer']['name'],

            qrcode: base64Decode(json['qrcode']),
            barcode: '${base_url}admin/${json['barcode']}',

            items : orderItemsList(json['items']),
        );
      }
}

class OrderItem{
  String id,sale_id,product_id,product_code,product_name,unit_price,quantity,subtotal,image,details,hsn_code,second_name ;

  OrderItem(
      {this.id,
      this.sale_id,
      this.product_id,
      this.product_code,
      this.product_name,
      this.unit_price,
      this.quantity,
      this.subtotal,
      this.image,
      this.details,
      this.hsn_code,
      this.second_name});

  factory OrderItem.fromJson(dynamic json){
    return OrderItem(
      id : json['id'],
      sale_id : json['sale_id'],
      product_id : json['product_id'],
      product_code : json['product_code'],
      product_name : json['product_name'],
      unit_price : format_money(json['unit_price']),
      quantity : json['quantity'],
      subtotal : format_money(json['subtotal']),
      image : getProductImageUrl(json['image'],thumb: true),
      details : json['details'],
      hsn_code : json['hsn_code'],
      second_name : json['second_name']
    );
  }
}

List<OrderItem> orderItemsList(dynamic json){
  List<OrderItem> oi = [];
  json.forEach((element){
    oi.add(OrderItem.fromJson(element));
  });
  return oi;
}