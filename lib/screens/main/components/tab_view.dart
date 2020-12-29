import 'package:content_placeholder/content_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:rentreerapide/models/category.dart';
import 'package:flutter/material.dart';
import 'package:rentreerapide/models/product.dart';
import 'product_list.dart';


class category_product extends StatefulWidget {
  List<Category> categories;
  dynamic standart_products;
  category_product({Key key,  this.categories , this.standart_products}) : super(key: key);

  @override
  _category_productState createState() => _category_productState();
}

class _category_productState extends State<category_product> with TickerProviderStateMixin<category_product> {
  bool placeholder = false;

  List<Widget> productList(List<Category> categories , dynamic standart_products){
    List<Widget> wds = [];
    List<String> addedCat = [];

    categories.forEach((element) {
      String category = categories[categories.indexOf(element)].category;
      List<Product> prs = getProductsOfCategory(standart_products, category);
      if(!addedCat.contains(category)){
        Widget w = IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(left: 1.0, right: 1.0),
            child: Column(children: <Widget>[
               Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5) , topRight: Radius.circular(5)),
                            color: Colors.orange
                        ),
                        padding: EdgeInsets.all(9.0),
                        // color: Colors.orange,
                        child: Row(
                          children: [
                            Expanded(child: Text('${category}', style: TextStyle(fontWeight: FontWeight.bold),)),

                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: (){},
                                  child: Icon(Icons.arrow_forward),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              Flexible(child: ProductList(prs)),
              SizedBox(height: 16.0,),
            ]),
          ),
        );
        wds.add(w);
        addedCat.add(category);
      }

    });
    return wds;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.categories == null) widget.categories = [];

    else{
      if(widget.categories.length > 0){
        if(widget.categories[0].category == 'placeholder') placeholder = true;
      }
    }
    if(widget.categories.length > 0){
            return Column(
        children: productList(widget.categories, widget.standart_products),
      );
    }

    else{
          return Column(
        children: [
          CategoryPlaceHolder(),
        ],
      );
    }
  }
}



class CategoryPlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      context: context,
      height: 80,
      width: 180,
    );
  }
}
