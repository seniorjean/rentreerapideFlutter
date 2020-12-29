import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final TabController controller;

  const CustomBottomBar({Key key, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: TabBar(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,

        tabs: [
          Container(width: (MediaQuery.of(context).size.width /4), margin: EdgeInsets.all(0.0) ,child: IconButton(icon: Icon(Icons.home, size: 30.6,), /* SvgPicture.asset('assets/icons/home_icon.svg', fit: BoxFit.fitWidth,),*/onPressed: () {controller.animateTo(0);},)),
          Container(width: (MediaQuery.of(context).size.width /4), margin: EdgeInsets.all(0.0) ,child: IconButton(icon: Icon(Icons.category, size: 30.6,), /* Image.asset('assets/icons/category_icon.png'),*/onPressed: () {controller.animateTo(1);},)),
          Container(width: (MediaQuery.of(context).size.width /4), margin: EdgeInsets.all(0.0) ,child: IconButton(icon: Icon(Icons.person, size: 30.6,), /* Image.asset('assets/icons/profile_icon.png'),*/onPressed: () {controller.animateTo(2);},)),
          Container(width: (MediaQuery.of(context).size.width /4), margin: EdgeInsets.all(0.0) ,child: IconButton(icon: Icon(Icons.shopping_cart, size: 30.6,), /* SvgPicture.asset('assets/icons/cart_icon.svg'),*/onPressed: () {controller.animateTo(3);},)),
        ],
        controller: controller,
        labelStyle: TextStyle(fontSize: 16.0 , color: Colors.white , fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14.0,),
        labelColor: Colors.white,
        unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
        // isScrollable: true,
        indicator: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
        ),
      ),
    );
  }
}
