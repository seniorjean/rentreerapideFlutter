import 'dart:convert';
import 'dart:ui';

import 'package:content_placeholder/content_placeholder.dart';
import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/helpers/sweetAlert.dart';
import 'package:rentreerapide/models/cart.dart';
import 'package:rentreerapide/screens/address/add_address_page.dart';
import 'package:rentreerapide/screens/payment/unpaid_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'components/cart_item_list.dart';

//TODO: NOT DONE. WHEEL SCROLL QUANTITY
class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  SwiperController swiperController = SwiperController();
  Cart cart;
  List<CartItem> cartItems =   [
    CartItem(name: 'placeholder'),
    CartItem(name: 'placeholder'),
    CartItem(name: 'placeholder'),
  ];

  _CheckOutPageState(){
    getCartData().then((data) => setState((){
      if(data['status'] == true){
        cart = data['cart'];
        cartItems = cart.content;
      }
      else{
        cartItems = [];
      }
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    if(appDataBox.containsKey('cart')){
      var cart_json = jsonDecode(appDataBox.get('cart'));
      cart = Cart.fromJson(cart_json);
      cartItems = cart.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget checkOutButton = InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AddAddressPage())),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            // gradient: mainButton,
          color: Colors.orange,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            // borderRadius: BorderRadius.circular(3.6)
        ),
        child: Center(
          child: Text("Payer",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    if(cart != null && (cartItems != null && cartItems.length > 0)){
      return Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: darkGrey),
          actions: <Widget>[
            IconButton(
              onPressed: (){
                sweetConfirm(context,
                  title: 'Confirmation',
                  type: 'warning',
                  desc: 'Voulez vous vraiment vider votre panier ?',
                  yesAction: (){
                    Navigator.of(context).pop();
                    showLoader(context);
                    emptyCart().then((value) => setState((){
                      if(appDataBox.containsKey('cart')){
                        appDataBox.delete('cart');
                        cartItems = [];
                        cart = null;
                      }
                      Navigator.of(context).pop();
                    }));
                  }
                );
              },
              icon: Icon(Icons.delete_forever,color: Colors.red,),
            ),

            IconButton(
              icon: Image.asset('assets/icons/denied_wallet.png'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UnpaidPage())),
            ),
          ],

          title: Text(
          'Panier',
          style: TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),

        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(9.0),
                height: (MediaQuery.of(context).size.height * 7) / 100,
                color: Color(0xffed1941),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total : ${format_money(cart.total_amount)}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    Text(cart.total_items+ ' Articles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                  ],
                ),
              ),

              Container(
                height: (MediaQuery.of(context).size.height * 80) / 100,
                // color: Colors.yellow,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.red,
                      height: (MediaQuery.of(context).size.height * 70) / 100,
                      child: ListView.builder(
                        itemBuilder: (_, index) => (cartItems[index].name != 'placeholder')?CartItemList(cartItems[index],
                          onRemove: (){
                          sweetConfirm(context,
                              desc: 'Etre vous sur de vouloir retirer ${cartItems[index].name} du panier ?',
                              yesAction: (){
                                Navigator.of(context).pop();
                                showLoader(context);

                                removeCartItem(cartItems[index].row_id).then((data) => setState(() {
                                  if(data['status'] == true){
                                    cart = data['cart'];
                                    cartItems = cart.content;
                                  }
                                  else{
                                    cartItems = [];
                                  }
                                  Navigator.of(context).pop();
                                  showMessage('success', 'Produit Retirer avec success');
                                }));
                              }
                          );
                        },

                          onIncrease: () async{
                            showLoader(context);
                            int qty = int.tryParse(cartItems[index].qty);
                            int q = qty + 1;
                            await updateCartItem(cartItems[index].row_id, q.toString()).then((data) =>   setState((){
                              if(data['status'] == true){
                                cart = data['cart'];
                                cartItems = cart.content;
                                qty = q;
                              }
                              hideLoader(context);
                            }));

                            return qty;
                          },

                          onDecrease:() async{
                            showLoader(context);
                            int qty = int.tryParse(cartItems[index].qty);
                            int q = qty - 1;
                            await updateCartItem(cartItems[index].row_id, q.toString()).then((data) =>   setState((){
                              if(data['status'] == true){
                                cart = data['cart'];
                                cartItems = cart.content;
                                qty = q;
                              }
                              hideLoader(context);
                            }));
                            return qty;
                          },

                        ) : CartItemPlaceHolder(),
                        itemCount: cartItems.length,
                      ),
                    ) ,
                  ],
                ),
              )
            ],
          ),
        ),

          bottomNavigationBar:  Container(
            padding: EdgeInsets.only(top: 1.0),
            width: MediaQuery.of(context).size.width,
            child: checkOutButton,
          ),
      );
    }

    else{
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: darkGrey),
          actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/icons/denied_wallet.png'),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UnpaidPage())),
            )
          ],
          title: Text(
            'Checkout',
            style: TextStyle(
                color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40.0),

              Padding(
                padding: const EdgeInsets.fromLTRB(9.0, 20 , 9.0 , 30.0),
                child: Text('Vous n\'avez pas d\'articles dans le panier' ,
                  style: TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              ),

              Icon(Icons.shopping_cart , size: 90.0, color: Colors.grey,)


            ],
          ),
        ),
      );
    }
  }
}

class Scroll extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    LinearGradient grT = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    LinearGradient grB = LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, 30),
        Paint()
          ..shader = grT.createShader(Rect.fromLTRB(0, 0, size.width, 30)));

    canvas.drawRect(Rect.fromLTRB(0, 30, size.width, size.height - 40),
        Paint()..color = Color.fromRGBO(50, 50, 50, 0.4));

    canvas.drawRect(
        Rect.fromLTRB(0, size.height - 40, size.width, size.height),
        Paint()
          ..shader = grB.createShader(
              Rect.fromLTRB(0, size.height - 40, size.width, size.height)));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class CartItemPlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height/5.4;
    double cardWidth = MediaQuery.of(context).size.width;
    return ContentPlaceholder(context: context, height: cardHeight, width: cardHeight);
  }
}

