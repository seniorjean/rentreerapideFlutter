import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:rentreerapide/screens/main/components/product_list.dart';
import 'package:rentreerapide/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'components/more_products.dart';
import 'components/product_display.dart';
import 'components/shop_bottomSheet.dart';
import 'view_product_page.dart';
//APERCU DU PRODUIT
class ProductPage extends StatefulWidget {
  final Product product;
  ProductPage({Key key, this.product}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState(product);
}

class _ProductPageState extends State<ProductPage> {
  final Product product;
  ProductDetails pd;
  int max_quantity = 0;
  bool in_wishlist = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _ProductPageState(this.product){
    getProductDetails(product.product_id).then((data) => setState((){
      pd = data;
      this.in_wishlist = pd.in_wishlist;
      this.max_quantity = int.tryParse(pd.stock)?? 0;
      // print("========== wishlist send=== : ${this.in_wishlist}");
    }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    Widget viewProductButton  = InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewProductPage(product: product,))),
      child: Container(
        height: 80,
        width: width / 1.5,
        decoration: BoxDecoration(
            gradient: mainButton,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Voir le produit",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );
    addToCartAction(){
      if(this.max_quantity>0){
            return () {
              _scaffoldKey.currentState.showBottomSheet((context) {
                return ShopBottomSheet(product_id: product.product_id, max_quantity: max_quantity, );
              });
            };
      }
      else return null;
    }
    buyAction(){
      if(this.max_quantity>0){
        return () {
          _scaffoldKey.currentState.showBottomSheet((context) {
            return ShopBottomSheet(product_id: product.product_id, max_quantity: max_quantity, );
          });
        };
      }
      else return null;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: darkGrey),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchPage())))
        ],

        title: Text(
          'Apercu Rapide',
          style: const TextStyle(color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //IMAGE , NAME , PRICES , MSG - SHARE - WISHLIST BUTTON
                ProductDisplay(product: product, in_wishlist: in_wishlist),

                Divider(),

                //ACHETER  - AJOUTER ACTION BUTTON
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          padding: EdgeInsets.all(12.6),
                          onPressed: buyAction(),
                          color: Color(0xffffc107),
                          disabledColor: Color.fromRGBO(225, 193, 7, 0.63),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline , color: Colors.white,),
                              SizedBox(width: 9.0,),
                              Text('Acheter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 9.0,),

                      Expanded(
                        child: MaterialButton(
                          padding: EdgeInsets.all(12.6),
                          onPressed: addToCartAction(),
                          color: Color(0xffffc107),
                          disabledColor: Color.fromRGBO(225, 193, 7, 0.63),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_shopping_cart , color: Colors.white,),
                              SizedBox(width: 9.0,),
                              Text('Ajouter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Divider(),

                //PRODUCT DETAILS
                (pd != null)?ProductDetailsSection(pd)
                    : Container(child: Center(child: CircularProgressIndicator())),

                Divider(),

                //MORE PRODUCTS
                Container(
                  color: BACKGROUND_COLOR,
                  child: Column(
                    children: [
                      MoreProducts(product.product_id),
                    ],
                  ),
                ),

                SizedBox(height: 18.0,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
