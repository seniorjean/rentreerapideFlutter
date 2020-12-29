import 'package:flutter/material.dart';
import 'package:rentreerapide/helpers/mix_helper.dart';

dynamic cls = [
  {"begin" : Color(0xffFCE183) , "end" : Color(0xffF68D7F)},
  {"begin" : Color(0xffF749A2) , "end" : Color(0xffFF7375)},
  {"begin" : Color(0xff00E9DA) , "end" : Color(0xff5189EA)},
  {"begin" : Color(0xffAF2D68) , "end" : Color(0xff632376)},
  {"begin" : Color(0xff36E892) , "end" : Color(0xff33B2B9)},
  {"begin" : Color(0xffF123C4) , "end" : Color(0xff668CEA)},
];

class Category{
  Color begin;
  Color end;
  String category;
  String image;
  String category_id;
  String total_items;
  String slug;

  Category(this.begin, this.end, this.category, this.image , {this.category_id = '' , this.total_items = '' , this.slug = ''});

  factory Category.fromJson(dynamic json){
    int color_index = rand(0, cls.length);
    return Category(cls[color_index]["begin"],cls[color_index]["end"] , json['name'] , getProductImageUrl(json['image'] , thumb: true),
      category_id: json['category_id'],
      total_items: json['total_items'],
      slug: json['slug']
    );
  }
}