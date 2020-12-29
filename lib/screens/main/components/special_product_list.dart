import 'package:content_placeholder/content_placeholder.dart';
import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:rentreerapide/screens/product/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SpecialProductList extends StatelessWidget {
  List<Product> products;
  bool placeholder = false;
  final SwiperController swiperController = SwiperController();
  SpecialProductList({Key key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardHeight = 200;
    double cardWidth = MediaQuery.of(context).size.width/1.2;
    if(products==null) products = [];
    else{
      if(products.length > 0){
        if(products[0].image == 'image_placeholder') placeholder = true;
      }
    }

    if(products.length > 0){
      return SizedBox(
        height: cardHeight,
        child: Swiper(
          autoplay: true,
          itemCount: products.length,
          itemBuilder: (_, index) {
            if(!placeholder){
              return SpecialProductCard(
                  height: cardHeight,
                  width: cardWidth,
                  product: products[index]
              );
            }
            else{
              return ProductPlaceHolder();
            }
          },
          scale: 0.8,
          controller: swiperController,
          viewportFraction: 0.6,
          loop: false,
          fade: 0.5,
        ),
      );
    }

    else{
      return Container(
        height: cardHeight,
        child: Card(
          child: Center(
            child: Text('Vide' , style: TextStyle(fontSize: 30.0),),
          ),
        ),
      );
    }


  }
}

class SpecialProductCard extends StatelessWidget {
  final Product product;
  final double height;
  final double width;

  const SpecialProductCard({Key key, this.product,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductPage(product: product))),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.6)),
            color: Colors.white,
          ),
          child: GridTile(
            header: Container(
              margin: EdgeInsets.only(top: 20.0 , right: 15.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.fromLTRB(3.6 ,6.3 , 3.6 , 6.3),
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
                  child: Hero(
                    tag: product.product_id+rand(10, 100).toString(),
                    child:CachedNetworkImage(
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                      errorWidget: (context, url , error) => loadingImageError,
                      imageUrl: '${product.thumbnail ?? ''}',
                      height: this.height/1.9,
                      width: this.width,
                      fit: BoxFit.contain,
                    ),
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
                            style: TextStyle())),
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
}

class ProductPlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height/2.7;
    double cardWidth = MediaQuery.of(context).size.width/1.8;
    return ContentPlaceholder(context: context, height: cardHeight, width: cardHeight);
  }
}





