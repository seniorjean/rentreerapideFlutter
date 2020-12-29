import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:rentreerapide/screens/product/components/product_card.dart';
import 'package:flutter/material.dart';

List<Product> products = [Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''),];

class MoreProducts extends StatefulWidget {
  final String product_id;
  MoreProducts(this.product_id);
  @override
  _MoreProductsState createState() => _MoreProductsState(this.product_id);
}

class _MoreProductsState extends State<MoreProducts> {

  final String product_id;

  _MoreProductsState(this.product_id){
    getOthersProducts(product_id).then((data)=>setState((){
      products = [];
      data.forEach((element) {
        products.add(element);
      });
    }));
  }

  @override
  Widget build(BuildContext context) {

    if(products.length > 0){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:3.6, bottom: 9.0 , right: 3.6),
            child: Text(
              'Les clients ont également consulté',
              style: TextStyle(color: Colors.black, shadows: shadow , fontSize: 14.4),
            ),
          ),

          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            height: cardHeight,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                return Padding(
                  ///calculates the left and right margins
                  ///to be even with the screen margin
                    padding: index == 0
                        ? EdgeInsets.only(left: 3.6, right: 6.3)
                        : index == 4
                        ? EdgeInsets.only(right: 3.6, left:6.3)
                        : EdgeInsets.symmetric(horizontal:6.3),
                    child: ProductCard(product: products[index],));
              },
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      );
    }

    else{
      return Padding(
        padding: const EdgeInsets.only(left:3.6, bottom: 9.0 , right: 3.6),
        child: Text(
          'Les clients ont également consulté',
          style: TextStyle(color: Colors.black, shadows: shadow , fontSize: 14.4),
        ),
      );
    }


  }
}
