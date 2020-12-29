import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/models/cart.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:flutter/material.dart';
import '../../product/product_page.dart';


class CartItemList extends StatefulWidget {
  final CartItem cartItem;
  final Function onRemove;
  final Function onIncrease;
  final Function onDecrease;
  CartItemList(this.cartItem, {Key key, this.onRemove , this.onDecrease , this.onIncrease}) : super(key: key);

  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  int qty = 1;
  TextEditingController qty_controller;
  bool in_wishlist = false;

  addToWishListAction(){
    // if(in_wishlist != true){
    //   return (){
    //     addToWishlist(widget.cartItem.product_id).then((value) => setState((){
    //       if(value ==true){
    //         in_wishlist = true;
    //       }
    //     }));
    //   };
    // }
    // else{
    //   return null;
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qty = int.tryParse(widget.cartItem.qty);
    in_wishlist = widget.cartItem.in_wishlist;
  }

  @override
  Widget build(BuildContext context) {
    qty_controller = TextEditingController(text: '${qty}');
    bool minusButtonEnabled = (int.tryParse(widget.cartItem.qty) > 1)?true : false;
    bool plusButtonEnabled = true;

    Function increaseQuantity(String row_id){
      return (){

        widget.onIncrease().then((data)=>setState((){
          qty = data;
        }));
      };
    }

    Function decreaseQuantity(){
      if(qty>1){
       return (){
        widget.onDecrease().then((data)=>setState((){
           qty = data;
         }));
       };
      }
      else return null;
    }


    return Container(
        margin: EdgeInsets.only(bottom: 9.2 , left: 9.0 , right: 9.0, top: 9.0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: shadow,
            borderRadius: BorderRadius.all(Radius.circular(3.6))),
      // color: Colors.black,
      child: Column(
        children: [
          Container(
            // color: Colors.blue,
            // height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Product p = Product.fromCartItem(widget.cartItem);
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductPage(product: p)));
                      },
                      child: Container(
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(3.6),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                          errorWidget: (context, url , error) => loadingImageError,
                          imageUrl: '${widget.cartItem.image}',
                          fit: BoxFit.cover,
                          height: 70.2,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.cartItem.name}' , style: TextStyle(fontSize: 12.0 , fontWeight: FontWeight.bold), maxLines: 2,),
                          SizedBox(height:3.6,),
                          Text('prix : ${widget.cartItem.price}', style: TextStyle(color: Colors.blue),),
                          Text('total : ${widget.cartItem.subtotal}', style: TextStyle(color: Colors.orange),),
                          SizedBox(height:3.6,),
                          Text('${widget.cartItem.warehouse_name}', style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),

         Container(height: 1.0, color: Colors.black12,),

          Container(
            padding: EdgeInsets.only(left: 9.0 , right: 9.0),
            height: 49,
            child: Row(
              children: [

                InkWell(
                  onTap: addToWishListAction(),
                  child: Icon(
                    (in_wishlist)?Icons.favorite : Icons.favorite_border,
                    color: (in_wishlist)?Color.fromRGBO(255, 193, 7 , 0.73) : Colors.orange,),
                ),
                SizedBox(width: 9.0,),
                InkWell(
                  onTap: widget.onRemove,
                  child: Row(
                    children: [
                      Icon(Icons.delete , color: Colors.orange,),
                      SizedBox(width: 6.3,),
                      Text('Retirer' , style: TextStyle(color: Colors.orange),)
                    ],
                  ),
                ),

                Expanded(flex: 1, child: SizedBox(width: 1.0,),),

                Expanded(
                  flex: 2,
                  child: Row(
                    children: [

                     Container(
                       width: 30.0,
                       child: MaterialButton(
                         onPressed: decreaseQuantity(),
                         padding: EdgeInsets.all(0.0),
                         color: Colors.orange,
                         disabledColor: Color.fromRGBO(255, 193, 7 , 0.73),
                         child: Icon(Icons.remove , color: Colors.white,),
                         shape: CircleBorder(),
                         height: 9.0,
                       ),
                     ),

                      SizedBox(width: 3.0,),

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 9.0),
                          child:  TextField(
                              textAlign: TextAlign.center,
                              obscureText: false,
                              controller: qty_controller,
                              readOnly: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true)
                          ),
                        ),
                      ),

                      SizedBox(width: 3.0,),

                      Container(
                        width: 30.0,
                        child: MaterialButton(
                          onPressed: increaseQuantity(widget.cartItem.row_id),
                          padding: EdgeInsets.all(0.0),
                          color: Colors.orange,
                          disabledColor: Colors.orangeAccent,
                          child: Icon(Icons.add , color: Colors.white,),
                          shape: CircleBorder(),
                          height: 9.0,
                        ),
                      ),

                    ],
                  ),
                )

              ],
            ),
          )
        ],
      )
    );
  }
}