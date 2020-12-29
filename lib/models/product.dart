import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as HTTP;
import 'dart:async';
import 'dart:convert';

import 'package:rentreerapide/models/cart.dart';

class Product{
  String image;
  String name;
  String description;
  String price;
  String promo_price;
  String product_id;
  String details;
  String supplier;
  String thumbnail;
  String category_name;
  Product(this.image, this.name, this.description, this.price , {this.thumbnail = '' , this.promo_price = '' , this.product_id , this.details = '' , this.supplier='' , this.category_name});

  factory Product.fomJson(dynamic json){
     return Product(
         getProductImageUrl(json['image'],thumb: false) ,
         json['name'] ,
         'product description' ,
         (json['promo_price']!= null)?json['price'] : randomPromoPrice(json['price']),
         promo_price: (json['promo_price'] != null)?json['promo_price'].toString() : json['price'] ,
         category_name: (json['category_name'] != null)?json['category_name'] : '' ,
         product_id: json['id'],
         details: json['details'],
         supplier: (json['warehouse_name']!=null)?json['warehouse_name'] : '',
         thumbnail: getProductImageUrl(json['image'],thumb: true) ,
     );
  }

  factory Product.fromProductDetails(ProductDetails p){
    return Product(
        getProductImageUrl(p.image,thumb: false),
        p.name, 'description',
        p.price ,
        details: p.details,
        product_id: p.id,
        supplier: p.warehouse_name,
        promo_price: p.promo_price,
        category_name: p.category,
        thumbnail: getProductImageUrl(p.image,thumb: true),
    );
  }

  factory Product.fromCartItem(CartItem c){
    return Product(
      c.big_image,
      c.name, '',
      cleanMoneyFormat(c.price),
      promo_price : cleanMoneyFormat(c.price),
      supplier: c.warehouse_name,
      product_id: c.product_id,
    );
  }
}

class ProductDetails{
  //PRODUCT
  String id ,code ,stock , views ,hsn_code ,warehouse_name , type , details , file , image , name , promo_price , price;

  //OTHERS
  String brand ,category ,unit , subcategory;

  bool in_wishlist;

  List<dynamic> images;


  ProductDetails(
      {this.id,
      this.code,
      this.stock,
      this.views,
      this.hsn_code,
      this.warehouse_name,
      this.type,
      this.details,
      this.file,
      this.brand,
      this.category,
      this.unit,
      this.images,
      this.image,
      this.name,
      this.promo_price,
      this.price,
      this.subcategory , this.in_wishlist});

  factory ProductDetails.fromJson(dynamic json){
    return ProductDetails(
      id:             json['product']['id'],
      code:           json['product']['code'],
      stock:          (json['product']['stock'].trim() != '1')? (int.tryParse(json['product']['stock']) - 1).toString()?? json['product']['stock'] : 'Rupture de stock',
      views:          json['product']['views'],
      image:          json['product']['image'],
      hsn_code:       json['product']['hsn_code'],
      brand:          (json['brand'] != false)?json['brand']['name'] : '',
      category:       json['category']['name'],
      unit:           json['unit']['name'],
      details:        json['product']['details'],
      file:           json['product']['file'],
      images:         json['images'],
      subcategory:    json['subcategory'],
      type:           json['product']['type'],
      name:           json['product']['name'],
      price:          json['product']['price'],
      promo_price:    json['product']['promo_price'],
      warehouse_name: json['product']['warehouse_name'],
      in_wishlist:    (json['in_wishlist'] != null)?json['in_wishlist'] : false,
    );
  }
}

class Filters{
  String limit,offset,query,category,subcategory,brand,promo,sorting,min_price,max_price,in_stock,page,featured,where_not_in,where_not_in_key;

  Filters(
      {this.limit,
        this.offset,
        this.query,
        this.category,
        this.subcategory,
        this.brand,
        this.promo,
        this.sorting,
        this.min_price,
        this.max_price,
        this.in_stock,
        this.page,
        this.featured,
        this.where_not_in,
        this.where_not_in_key});
  factory Filters.fromJson(dynamic json){
    return Filters(
      limit : json['limit'].toString(),
      offset : json['offset'].toString(),
      query : json['query'],
      category : json['category'],
      subcategory : json['subcategory'],
      brand : json['brand'],
      promo : json['promo'],
      sorting : json['sorting'],
      min_price : json['min_price'],
      max_price : json['max_price'],
      in_stock : json['in_stock'],
      page : json['page'],
      featured : json['featured'],
      where_not_in : json['where_not_in'],
      where_not_in_key : json['where_not_in_key'],
    );
  }
}

class ProductFromPage{
  String current_page;
  int total_page;
  Filters filters;
  List<Product> products;

  ProductFromPage(
      {this.current_page, this.total_page, this.filters, this.products});

  factory ProductFromPage.fromJson(dynamic json){
    return ProductFromPage(
      current_page: json['info']['current_page'],
      total_page: json['info']['total_page'],
      filters: Filters.fromJson(json['filters']),
      products: productListFronJson(json['products'])
    );
  }
}


List<Product> productListFronJson(dynamic json){
  List<Product> prdc = [];
  json.forEach((element){
    prdc.add(Product.fomJson(element));
  });

  return prdc;
}


Future<dynamic> getProducts() async{
  var response = await HTTP.get(get_api_url('shop/productByType'));
  var responseJson = jsonDecode(response.body);

  return responseJson;
}

Future<List<Widget>> getSlides() async{
  var response = await HTTP.get(get_api_url('shop/getSlides'));
  var responseJson = jsonDecode(response.body);
  List<Widget> slides = [];
  for(var image in responseJson){
    Widget sl = SlideItem(image);
    slides.add(sl);
  }

  return slides;
}

class SlideItem extends StatelessWidget {
  final String image;
  SlideItem(this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(3.0),
        child: ClipRRect(
            // borderRadius: BorderRadius.all(Radius.circular(5.4)),
            child: Stack(
              children: <Widget>[

                CachedNetworkImage(
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  errorWidget: (context, url , error) => loadingImageError,
                  imageUrl: '${getSlideImageUrl(this.image)}',
                  height: MediaQuery.of(context).size.height,
                  width: 1000.0,
                  fit: BoxFit.cover,
                ),
              ],
            )));
  }
}

List<Product> getProductsOfCategory(dynamic json , String category_name){
  List<Product> ps = [];
  json.forEach((element) {
    if(element['category_name'] == category_name){
      ps.add(Product.fomJson(element));
    }
  });
  return ps;
}

Future<List<Product>> getOthersProducts(String product_id) async{
  var response = await HTTP.get(get_api_url('products/getOrthersProduct/${product_id}'));
  var responseJson = jsonDecode(response.body);
  var productsJson = responseJson['products'];
  List<Product> products = [];
  for(var json in productsJson){
    products.add(Product.fomJson(json));
  }
  return products;
}

Future<ProductDetails> getProductDetails(String product_id) async{
  String user_id = '';
  if(appDataBox.containsKey('user_id')){
    user_id = appDataBox.get('user_id');
  }
  var response = await HTTP.get(get_api_url('products/getProductDetails/${product_id}/${user_id}'));
  var responseJson = jsonDecode(response.body);
  return ProductDetails.fromJson(responseJson);
}


Future<ProductFromPage> getProductsByPage(String page_number) async{
  print('stop 2 ok');
  var response = await HTTP.post(get_api_url('shop/search'), body: {
    'page':page_number
  });
  var responseJson = jsonDecode(response.body);
  return ProductFromPage.fromJson(responseJson);
}

