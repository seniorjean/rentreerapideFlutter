import 'package:rentreerapide/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/models/Order.dart';
import 'package:rentreerapide/screens/order/order_details_page.dart';

class OneTimeOrder extends StatelessWidget {
  OneTimePayment otp;
  OneTimeOrder(this.otp);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MaterialButton(
        color: Colors.white,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailPage(otp.order_id, delivery_status: otp.delivery_status,),));
        },
        child: Container(
          padding: EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: Text('Reference'),),
                  Expanded(child: Text('${otp.reference_no}'))
                ],
              ),
              SizedBox(height: 6.3,),
              Row(
                children: [
                  Expanded(child: Text('Status de paiement'),),
                  Expanded(
                    child: (otp.payment_status == 'paid')?Row(
                      children: [
                        Icon(Icons.check_circle , color: Colors.green,),
                        Text('Payé')
                      ],
                    ) : Row(
                      children: [
                        Icon(Icons.info_outline , color: Colors.blue,),
                        Text('En attente')
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 6.3,),
              Row(
                children: [
                  Expanded(child: Text('État de ventes'),),
                  Expanded(child: Text('${otp.sale_status}'))
                ],
              ),
              SizedBox(height: 6.3,),
              Row(
                children: [
                  Expanded(child: Text('État de livraison'),),
                  Expanded(child: Text('${otp.delivery_status}'))
                ],
              ),
              SizedBox(height: 6.3,),
              Row(
                children: [
                  Expanded(child: Text('Achat'),),
                  Expanded(child: Text('${format_money('${otp.total}')}', style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
              SizedBox(height: 6.3,),
              Row(
                children: [
                  Expanded(child: Text('Livraison'),),
                  Expanded(child: Text('${format_money('${otp.shipping}')}'))
                ],
              ),

              Row(
                children: [
                  Expanded(child: Text('Total'),),
                  Expanded(child: Text('${format_money('${otp.grand_total}')}'))
                ],
              ),





            ],
          ),
        ),
      ),
    );
  }
}
class OneTimeOrders extends StatelessWidget {
  List<OneTimePayment> otps;

  OneTimeOrders(this.otps);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ...otps.map((e) => OneTimeOrder(e)).toList(),
        ],
      ),
    );
  }
}

class InstallmentOrder extends StatelessWidget {
  InstallmentPayment itp;

  InstallmentOrder(this.itp);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MaterialButton(
          onPressed: (itp.num_of_week == null || itp.weekly_pay == null)?(){

          }
          : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailPage(itp.order_id, delivery_status: itp.delivery_status,),));
          },
        padding: EdgeInsets.all(2.7),
        child: Container(
          padding: EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: Text('Reference'),),
                  Expanded(child: Text('${itp.reference_no}'))
                ],
              ),
              SizedBox(height: 6.3,),

              Row(
                children: [
                  Expanded(child: Text('Status de paiement'),),
                  Expanded(
                    child: (itp.payment_status == 'paid')?Row(
                      children: [
                        Icon(Icons.check_circle , color: Colors.green,),
                        Text('Payé')
                      ],
                    ) : Text('En Attente'),
                  )
                ],
              ),
              SizedBox(height: 6.3,),

              Row(
                children: [
                  Expanded(child: Text('État des ventes'),),
                  Expanded(child: Text('${itp.sale_status}'))
                ],
              ),
              SizedBox(height: 6.3,),

              Row(
                children: [
                  Expanded(child: Text('Achat'),),
                  Expanded(child: Text('${format_money('${itp.total}')}'))
                ],
              ),
              SizedBox(height: 6.3,),


              Row(
                children: [
                  Expanded(child: Text('Livraison'),),
                  Expanded(child: Text('${format_money('${itp.shipping}')}'))
                ],
              ),

              SizedBox(height: 6.3,),

              Row(
                children: [
                  Expanded(child: Text('Frais de versement'),),
                  Expanded(child: Text('${format_money('${itp.installment_fee}')}'))
                ],
              ),

              SizedBox(height: 6.3,),

              Row(
                children: [
                  Expanded(child: Text('Total'),),
                  Expanded(child: Text('${format_money('${itp.grand_total}')}'))
                ],
              ),

              SizedBox(height: 6.3,),

              Row(
                children: [
                  Expanded(child: Text('Progession'),),
                  Expanded(
                    child: LinearPercentIndicator(
                      width: (MediaQuery.of(context).size.width * 40) /100,
                      lineHeight: 14.0,
                      percent: double.tryParse('${getPercentage(itp.total, itp.paid)}') / 100,
                      backgroundColor: Color.fromRGBO(225, 225, 225, 0.8),
                      progressColor: Colors.green,
                      alignment: MainAxisAlignment.start,
                      animation: true,
                      center: Text('${getPercentage(itp.total, itp.paid)}%' , style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),

              (itp.num_of_week == null || itp.weekly_pay == null)?
              Row(
                children: [
                  Expanded(child: Text('Action Requis'),),
                  Expanded(
                    child: MaterialButton(onPressed: (){},
                      color: Colors.yellow,
                      padding: EdgeInsets.all(2.7),
                      child: Text('Achever la commande'),
                    ),
                  )
                ],
              )
                  : Container(),

            ],
          ),
        ),
      ),
    );
  }
}
class InstallmentOrders extends StatelessWidget {
  List<InstallmentPayment> itps;
  InstallmentOrders(this.itps);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          ...itps.map((e) => InstallmentOrder(e)).toList(),
        ],
      ),
    );
  }
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Order order;
  bool loading = true;
  List<OneTimePayment> onetime_payments;
  List<InstallmentPayment> installment_payments;

  _OrdersPageState(){
    getOrders().then((data) => setState((){
      order = data;
      onetime_payments = data.onetimePayments;
      installment_payments = data.installmentPayments;
      loading = false;
    }));
  }

  AppBar appbar =  AppBar(
  iconTheme: IconThemeData(
  color: Colors.black,
  ),
  brightness: Brightness.light,
  backgroundColor: Colors.transparent,
  title: Text(
  'Mes Commandes',
  style: TextStyle(color: darkGrey),
  ),
  elevation: 0,
  );

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width / 1.2;
    double cardHeight = 200;

    if(loading){
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: appbar,
        body: Container(
          child:Center(
            child: CircularProgressIndicator(),
          )
        ),
      );
    }

    if(onetime_payments.length == 0 || installment_payments.length == 0){
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: appbar,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(9.0),
              child: Center(
                child: Text('Aucune Commande'),
              ),
            )
          ],
        ),
      );
    }

    else{
      return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: appbar,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: Text('Espece : (${(onetime_payments != null)?onetime_payments.length : ''})'),),
                (onetime_payments != null)? OneTimeOrders(onetime_payments)
                    : Container(),

                Center(child: Text('Versements : (${(installment_payments != null)?installment_payments.length : ''})'),),
                (installment_payments != null)? InstallmentOrders(installment_payments)
                    : Container(),
              ],
            ),
          )
      );
    }


  }
}
