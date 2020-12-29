import 'package:cached_network_image/cached_network_image.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:flutter/material.dart';
import '../../../app_properties.dart';
import '../product_page.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const ProductCard({Key key, this.product,this.height = 200,this.width = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(product.name != 'placeholder'){
      return InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductPage(product: product))),
          child: Container(
            height: this.height,
            width: this.width,
            margin: EdgeInsets.only(right: 1 , bottom: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              color: Colors.white,
            ),
            child: GridTile(
              header: Container(
                margin: EdgeInsets.only(top: 20.0 , right: 15.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(3.6, 6.3, 3.6, 6.3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.3)),
                        color: Color(0xfffeeedd)
                    ),
                    child: Text(
                      '${getDiscount(product.price, product.promo_price)}%' ,
                      style: TextStyle(fontWeight: FontWeight.bold , color: Color(0xfff7a853)),
                    ),
                  ),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child:CachedNetworkImage(
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url , error) => loadingImageError,
                      imageUrl: '${product.thumbnail ?? ''}',
                      height: this.height/1.9,
                      width: this.width,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 5.4 , right: 5.4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            strutStyle: StrutStyle(fontSize: 12.0),
                            text: TextSpan(
                                style: TextStyle(color: darkGrey),
                                text: product.name?? ''
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  (product.supplier!=null)?Container(
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.only(left: 3.6, right: 3.6),
                          child: Text('${product.supplier}',
                              style: TextStyle(color: Colors.orange , fontWeight: FontWeight.bold , fontStyle: FontStyle.italic , fontSize: 13.5))),
                    ),
                  ): Container(),

                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(right: 6.3 , bottom: 3.6),
                      child: Text('${format_money((product.promo_price != '')?product.promo_price : product.price)}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    }

    else{
      return ProductPlaceHolder();
    }
  }
}

class ProductPlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(context: context, height: 200, width: 200);
  }
}
