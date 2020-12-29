import 'package:content_placeholder/content_placeholder.dart';
import 'package:rentreerapide/models/category.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryCard extends StatelessWidget {

  final Category category;
  const CategoryCard({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 80,
                width: 90,
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    category.category,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              Container(
                height: 80,
                width: 90,
                decoration: BoxDecoration(
                    gradient:RadialGradient(colors: [category.begin,category.end],
                        center: Alignment(0, 0),
                        radius: 0.8,
                        focal: Alignment(0, 0),
                        focalRadius: 0.1)
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child:FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: '${category.image}',
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Categories extends StatelessWidget {
  List<Category> categories;
  Categories(this.categories);
  @override
  Widget build(BuildContext context) {
    bool placeholder = false;
    if(categories == null) categories = [];
    else{
      if(categories[0].category == 'placeholder') placeholder = true;
    }
    return  Container(
        margin: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height / 9,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, index){
              return (!placeholder)? CategoryCard(
                category: categories[index],
              )
                  : CategoryPlaceHolder();
            }));
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