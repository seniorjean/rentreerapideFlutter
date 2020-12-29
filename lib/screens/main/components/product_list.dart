import 'package:rentreerapide/app_properties.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:rentreerapide/screens/product/components/product_card.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  List<Product> products = [];
  ProductList(this.products);

  @override
  Widget build(BuildContext context) {

    return Container (
      height: 200 ,//* (products.length / 2),
      child: Column(
        children: <Widget>[
          // Flexible(
          //   child: Container(
          //     // color: Colors.black,
          //     child: GridView.builder(
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 2,
          //         childAspectRatio: 0.8,
          //         crossAxisSpacing: 0.9,
          //         mainAxisSpacing: 1.9
          //       ),
          //       itemCount: products.length,
          //       itemBuilder: (context, index){
          //         return ProductCard(product: products[index],height: cardHeight, width: cardWidth,);
          //       },
          //     )
          //   ),
          // ),

          Flexible(
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,

              itemBuilder: (context, index) {
                return ProductCard(product: products[index],height: cardHeight, width: cardWidth,);
              },
            ),
          ),


        ],
      ),
    );
  }
}

//BUILD PRODUCT DETAILS FROM PRODUCT DETAILS OBJEC
class ProductDetailsSection extends StatelessWidget {
  final ProductDetails pd;
  TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.bold
  );

  ProductDetailsSection(this.pd);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(9.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 6.3),
            child: Text('Description'),
          ),
          SizedBox(height: 6.3,),
          Row(children: [Expanded(child: Text('Fournisseur : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.warehouse_name}'))],),
          Divider(),

          Row(children: [Expanded(child: Text('Stock : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.stock}' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.red),))],),
          Divider(),

          Row(children: [Expanded(child: Text('Catégorie : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.category}'))],),
          Divider(),

          Row(children: [Expanded(child: Text('Unité: ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.unit}'))],),

          (pd.brand != '' && pd.brand != null)?
          Row(children: [Expanded(child: Text('Marque : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.brand}'))],)
              : SizedBox(height: 0.0),

          (pd.details != null)?  Divider() :  SizedBox(height: 0.0,),
          (pd.details != null)? SizedBox(height: 18.0,) :  SizedBox(height: 0.0,),
          (pd.details != null)?Container(
            // color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Details' , style: labelStyle,),
                SizedBox(height: 9.0,),
                Text('${pd.details}'),
              ],
            ),
          ):SizedBox(height: 0.0),
        ],
      ),
    );
  }
}


//BUILD PRODUCT DETAILS FROM PRODUT_ID
class ProductDetailsView extends StatefulWidget {
  final String product_id;

  ProductDetailsView(this.product_id);

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState(this.product_id);
}
class _ProductDetailsViewState extends State<ProductDetailsView> {
  ProductDetails pd;
  TextStyle labelStyle = TextStyle(
    fontWeight: FontWeight.bold
  );

  final String product_id;
  _ProductDetailsViewState(this.product_id){
    getProductDetails(product_id).then((data) => setState((){
      pd = data;
    }));
  }

  @override
  Widget build(BuildContext context) {

    if(pd != null){
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(9.0),
        child: Column(
          children: [
            Row(children: [Expanded(child: Text('Fournisseur : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.warehouse_name}'))],),
            Divider(),

            Row(children: [Expanded(child: Text('Stock : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.stock}' , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.red),))],),
            Divider(),

            Row(children: [Expanded(child: Text('Catégorie : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.category}'))],),
            Divider(),

            Row(children: [Expanded(child: Text('Unité: ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.unit}'))],),

            (pd.brand != '' && pd.brand != null)?
            Row(children: [Expanded(child: Text('Marque : ' , style: labelStyle)), SizedBox(width:9.0), Expanded(child: Text('${pd.brand}'))],)
            : SizedBox(height: 0.0),

            (pd.details != null)?  Divider() :  SizedBox(height: 0.0,),
            (pd.details != null)? SizedBox(height: 18.0,) :  SizedBox(height: 0.0,),
            (pd.details != null)?Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Details' , style: labelStyle,),
                  SizedBox(height: 9.0,),
                  Text('${pd.details}'),
                ],
              ),
            ):SizedBox(height: 0.0),
          ],
        ),
      );
    }
    else{
      return Container(child: Center(child: CircularProgressIndicator(),),);
    }
  }
}

