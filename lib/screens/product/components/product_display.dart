import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:rentreerapide/screens/rating/rating_page.dart';
import 'package:flutter/material.dart';
import 'package:rentreerapide/models/cart.dart';

class ProductDisplay extends StatefulWidget {
  final Product product;
  final in_wishlist;
  const ProductDisplay({Key key, this.product , this.in_wishlist}) : super(key: key);

  @override
  _ProductDisplayState createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  IconData wishlist_icon = Icons.favorite_border;
  bool in_wishlist = null;
  double actionButtonMinWidth = 60.0;
  double actionButtonConWidth = 60.3;
  double actionButtonIconSize = 20.0;

  addToWishListAction(){
    if(in_wishlist == null){
      return (){
        addToWishlist(widget.product.product_id).then((value) => setState((){
          if(value ==true){
            in_wishlist = true;
          }
        }));
      };
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.in_wishlist){
      in_wishlist = true;
    }
    return Column(
      children: <Widget>[
        //Image
        Container(
          color: Colors.white,
          constraints: BoxConstraints(
            maxHeight: 250.0,
          ),
          child: Hero(
            tag: widget.product.product_id+rand(10, 100).toString(),
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url , error) => loadingImageError,
              imageUrl: '${widget.product.image}',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
            ),
          ),
        ),

       SizedBox(height: 9.0,),

        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product.name , style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ),

              Divider(),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child:Padding(
                      padding: const EdgeInsets.fromLTRB(3.6, 6.3, 3.6, 6.3),
                      child: (widget.product.promo_price != null)?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(format_money(widget.product.price) , style: TextStyle(decoration: TextDecoration.lineThrough , fontWeight: FontWeight.bold , fontSize: 16.0 , color: Colors.black54), ),
                            Text(format_money(widget.product.promo_price) ,  style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0 , color: Colors.red)),
                          ]
                      )
                          :Text(format_money(widget.product.price) ,
                          style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18.0 , color: Colors.red)),
                    ) ,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(3.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: actionButtonConWidth,
                          child: MaterialButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RatingPage(widget.product))),
                            minWidth: actionButtonMinWidth,
                            padding: EdgeInsets.all(0.0),
                            child: Icon(Icons.comment, color: Colors.white , size: actionButtonIconSize,),
                            elevation: 0.0,
                            shape: CircleBorder(),
                            color: Color(0xffffd408),
                          ),
                        ),
                        // SizedBox(width: 9.0),
                        Container(
                          width: actionButtonConWidth,
                          child: MaterialButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RatingPage(widget.product))),
                            minWidth: actionButtonMinWidth,
                            child:
                            Icon(Icons.share, color: Colors.white , size: actionButtonIconSize,),
                            elevation: 0.0,
                            shape: CircleBorder(),
                            color: Color(0xff009cdf),
                          ),
                        ),
                        // SizedBox(width: 9.0),

                        //ADD TO WISHLIST
                        Container(
                          width: actionButtonConWidth,
                          child: MaterialButton(
                            onPressed:addToWishListAction(),
                            padding: EdgeInsets.all(0.0),
                            minWidth: actionButtonMinWidth,
                            disabledColor:Color.fromRGBO(237 ,25 ,64 , 0.72),
                            child: Icon(
                                (in_wishlist != null)?(in_wishlist)?Icons.favorite : Icons.favorite_border : (widget.in_wishlist)?Icons.favorite : Icons.favorite_border, size: actionButtonIconSize,
                                color: Colors.white),
                            elevation: 0.0,
                            shape: CircleBorder(),
                            color: Color(0xffed1941),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
