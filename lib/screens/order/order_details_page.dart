import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/models/Order.dart';

import '../../app_properties.dart';
TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);
TextStyle labelStyle2 = TextStyle(color: Colors.blueGrey);

class Item extends StatelessWidget {
  OrderItem oi;
  Item(this.oi);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url , error) => loadingImageError,
              imageUrl: '${oi.image}',
              // height: 90,
              // width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left:6.3,right:3.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${oi.product_name}', style: TextStyle(fontWeight:FontWeight.bold),maxLines: 2,),
                  SizedBox(height:3.6),
                  Row(
                    children: [
                      Text('Prix : ',style:labelStyle2),
                      Text('${oi.unit_price}', style: TextStyle(fontWeight:FontWeight.bold),maxLines: 2,)
                    ],
                  ),

                  SizedBox(height:3.6),
                  Row(
                    children: [
                      Text('Quantite : ',style:labelStyle2),
                      Text('${cleanDecimalFormat(oi.quantity)}', style: TextStyle(fontWeight:FontWeight.bold),maxLines: 2,)
                    ],
                  ),

                  SizedBox(height:3.6),
                  Row(
                    children: [
                      Text('Total : ',style:labelStyle2),
                      Text('${oi.subtotal}', style: TextStyle(fontWeight:FontWeight.bold),maxLines: 2,)
                    ],
                  ),
                  SizedBox(height:3.6),
                  (oi.details != null)?Row(
                    children: [
                      Text('Details : ',style:labelStyle),
                      Text('${oi.details}', style: TextStyle(color: Colors.black12),maxLines: 2,)
                    ],
                  ) : Container()


                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Items extends StatelessWidget {
  List<OrderItem> ois;
  Items(this.ois);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ...ois.map((e) => Item(e)).toList()
        ],
      ),
    );
  }
}


class OrderDetailPage extends StatefulWidget {
  String order_id;
  String delivery_status;
  OrderDetailPage(this.order_id , {this.delivery_status});
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState(this.order_id);
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String order_id;
  bool loading = true;
  OrderDetails orderdetails;
  List<OrderItem> order_items;
  _OrderDetailPageState(this.order_id){
    getOrderDetails(order_id).then((data)=>setState((){
      orderdetails = data;
      order_items = orderdetails.items;
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

    else{
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: appbar,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: EdgeInsets.only(left:9.0,right: 9.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        flex:2,
                        child: Container(
                          padding: EdgeInsets.only(left: 9.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Date : ',style: labelStyle,),
                                  Expanded(child: Text('${orderdetails.date}'))
                                ],
                              ),

                              Row(
                                children: [
                                  Text('Reference : ',style:labelStyle),
                                  Expanded(child: Text('${orderdetails.reference_no}'))
                                ],
                              ),

                              Row(
                                children: [
                                  Text('Paiement : ',style:labelStyle),
                                  Expanded(child: Text('${orderdetails.payment_status}'))
                                ],
                              ),

                              Row(
                                children: [
                                  Text('Livraison : ', style:labelStyle),
                                  Expanded(child: Text('${widget.delivery_status}'))
                                ],
                              ),

                              Row(
                                children: [
                                  Text('Total : ', style:labelStyle),
                                  Expanded(child: Text('${orderdetails.grand_total}'))
                                ],
                              ),

                              Row(
                                children: [
                                  Text('${lang('paid')} : ', style:labelStyle),
                                  Expanded(child: Text('${orderdetails.paid}'))
                                ],
                              ),

                              Row(
                                children: [
                                  Text('Reste : ', style:labelStyle),
                                  Expanded(child: Text('${orderdetails.balance}'))
                                ],
                              ),


                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex:1,
                          child: Container(
                            child: Image.memory(orderdetails.qrcode,
                              fit: BoxFit.contain,
                            ),
                            color: Colors.blue,
                            // height: 60.30,
                          )
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height:6.3),

                Container(
                    color: BACKGROUND_COLOR,
                    child: Column(
                  children: [
                    Text('${orderdetails.total_items} Articles' , style: TextStyle(fontSize: 20.7 , fontWeight:FontWeight.bold),),
                    Divider(),
                    Items(order_items)
                  ],
                )),

                Divider(),

                Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(left:9.0,right:9.0),
                    child:  Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left:6.3),
                                color: Colors.black12,
                                child: Text('BarCode'),
                              ),
                              Row(
                                children: [
                                  Expanded(child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                    errorWidget: (context, url , error) => loadingImageError,
                                    imageUrl: '${orderdetails.barcode}',
                                    height: 100,
                                    // width: 200,
                                    fit: BoxFit.contain,
                                  ),)
                                ],
                              ),
                              SizedBox(height:9.0)

                            ],
                          ),
                        ),
                      ],
                    )
                ),

                SizedBox(height:6.3),

                Card(
                  color: Colors.white,
                  margin: EdgeInsets.only(left:9.0,right:9.0),
                  child:  Row(
                    children: [
                      Expanded(
                        flex:2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left:6.3),
                              color: Colors.black12,
                              child: Text('Facturier'),
                            ),
                            Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 6.3,),
                                Text('${orderdetails.company}')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.phone),
                                SizedBox(width: 6.3,),
                                Text('${orderdetails.phone}')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.email),
                                SizedBox(width: 6.3,),
                                Text('${orderdetails.email}')
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Container(
                          // color: Colors.orange,
                          child: Image.asset('assets/icons/usd.png',
                            height: 90.0,
                          ),
                        ),
                      )
                    ],
                  )
                ),

                SizedBox(height:6.3),
                Card(
                    color: Colors.white,
                    margin: EdgeInsets.only(left:9.0,right:9.0),
                    child:  Row(
                      children: [
                        Expanded(
                          flex:2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left:6.3),
                                color: Colors.black12,
                                child: Text('Livraison'),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 6.3,),
                                  Text('${orderdetails.shp_name}')
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 6.3,),
                                  Text('${orderdetails.shp_line1}')
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 6.3,),
                                  Text('${orderdetails.shp_line2}')
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_city),
                                  SizedBox(width: 6.3,),
                                  Text('${orderdetails.shp_city}')
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(Icons.email),
                                  SizedBox(width: 6.3,),
                                  Text('${orderdetails.shp_phone}')
                                ],
                              ),

                              Row(
                                children: [
                                  Icon(Icons.email),
                                  SizedBox(width: 6.3,),
                                  Text('${orderdetails.shp_email}')
                                ],
                              ),



                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            // color: Colors.orange,
                            child: Image.asset('assets/secondScreen.png',
                              height: 90.0,
                            ),
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(height:6.3),

                (orderdetails.payment_status != lang('paid'))?
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: MaterialButton(
                              onPressed: (){},
                              color: Colors.orange,
                              child: Text('Efectuer le paiement', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    )
                    :Container(),
              ],
            ),
          ),
        ),
      );
    }
  }
}
