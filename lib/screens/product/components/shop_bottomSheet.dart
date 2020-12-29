import 'package:flutter/cupertino.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rentreerapide/helpers/sweetAlert.dart';
import 'package:rentreerapide/models/cart.dart';
import 'package:flutter/material.dart';

class ShopBottomSheet extends StatefulWidget {
  String product_id;
  int max_quantity = 1000;
  ShopBottomSheet({this.product_id = '0' , this.max_quantity = 1000});

  @override
  _ShopBottomSheetState createState() => _ShopBottomSheetState(this.max_quantity);
}

class _ShopBottomSheetState extends State<ShopBottomSheet> {
  int qty = 1;
  double qty2 = 1.0;
  final int max_quantity;
  _ShopBottomSheetState(this.max_quantity);
  TextEditingController qty_controller;

  decreaseQuantity(){
    if(qty > 1){
      return (){
        setState(() {
            qty--;
        });
      };
    }
    else return null;
  }

  increaseQuantity(){
    if(qty < this.max_quantity){
      return (){
        setState(() {
          qty++;
        });
      };
    }
    else return null;
  }

  @override
  Widget build(BuildContext context) {
    qty_controller = TextEditingController(text: '${qty}');
    Widget confirmButton = InkWell(
      onTap: () async {
        showLoader(context);
        bool result = await addToCart(widget.product_id, qty.toString());
        hideLoader(context);
        if(result){
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom == 0
                ? 20
                : MediaQuery.of(context).padding.bottom),
        child: Center(
            child: new Text("Confirmer",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0))),
        decoration: BoxDecoration(
            color: Color(0xffed1941),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
      ),
    );

    return Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(225, 225, 225, 0.95),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(9.0, 18.0, 9.0, 12.0),
              child: Text('Ajuster la quantité à ajouter au panier' , style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),),
            ),

            // Theme(
            //   data: ThemeData(
            //       accentColor: Colors.orange,
            //       textTheme: TextTheme(
            //         headline: TextStyle(
            //             // fontFamily: 'Montserrat',
            //             fontSize: 35,
            //             color: Colors.orange,
            //             fontWeight: FontWeight.bold),
            //         body1: TextStyle(
            //           fontFamily: 'Montserrat',
            //           fontSize: 30,
            //           color: Colors.grey[400],
            //         ),
            //       )),
            //   child: Container(
            //     // color: Colors.white,
            //     // width: 200,
            //     child: NumberPicker.horizontal(
            //       initialValue: qty,
            //       minValue: 1,
            //       maxValue: max_quantity,
            //       onChanged: (value) {
            //         setState(() {
            //           qty = value;
            //         });
            //       },
            //       itemExtent: 40,
            //       // listViewWidth:120,
            //       highlightSelectedValue: true,
            //       // scrollDirection: Axis.horizontal,
            //
            //     ),
            //   ),
            // ),

            SizedBox(height: 9.0,),

            // Container(
            //   height: 150,
            //   child: Container(
            //     child: Row(
            //       children: [
            //         SizedBox(width: 9.0,),
            //         MaterialButton(
            //           padding: EdgeInsets.only(top: 9.0 , bottom: 9.9),
            //           disabledColor: Color.fromRGBO(225, 0, 0, 0.63),
            //           onPressed: decreaseQuantity(),
            //           color: Colors.red,
            //           child: Icon(Icons.remove , color: Colors.white,),
            //         ),
            //         SizedBox(width: 9.0,),
            //
            //         Expanded(
            //           child:  TextField(
            //             textAlign: TextAlign.center,
            //               obscureText: false,
            //               controller: qty_controller,
            //               readOnly: true,
            //               decoration: InputDecoration(
            //                   fillColor: Colors.white,
            //                   border: OutlineInputBorder(
            //                     borderRadius: const BorderRadius.all(
            //                       const Radius.circular(9.0),
            //                     ),
            //                   ),
            //                   filled: true)
            //           ),
            //         ),
            //
            //         SizedBox(width: 9.0,),
            //         MaterialButton(
            //           padding: EdgeInsets.only(top: 9.0 , bottom: 9.9),
            //           onPressed: increaseQuantity(),
            //           disabledColor: Color.fromRGBO(225, 0, 0, 0.63),
            //           color: Colors.red,
            //           child: Icon(Icons.add , color: Colors.white,),
            //         ),
            //         SizedBox(width: 9.0,),
            //
            //       ],
            //     ),
            //   )
            // ),

            Container(
              height: 150,
              // color: Colors.white,
              child: CupertinoPicker(
                  // backgroundColor: Colors.blue,
                  itemExtent: 30,
                  useMagnifier: true,
                  magnification: 1.4,

                  onSelectedItemChanged: (int index){
                    setState(() {
                      qty = index+1;
                    });
                  },
                  children: <Widget>[
                    for(int i = 1 ; i<=max_quantity ; i++)
                      Container(
                        padding: EdgeInsets.only(top: 3.9),
                          child: Text('${i}', style: TextStyle(color: Colors.red),)
                      ),
                  ]
              )
            ),


            confirmButton
          ],
        ));
  }
}


