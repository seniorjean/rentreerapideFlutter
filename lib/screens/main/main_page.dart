import 'package:content_placeholder/content_placeholder.dart';
import 'package:rentreerapide/screens/category/category_list_page.dart';
import 'package:rentreerapide/screens/main/home_page.dart';
import 'package:rentreerapide/screens/profile_page.dart';
import 'package:rentreerapide/screens/shop/check_out_page.dart';
import 'package:flutter/material.dart';

class SlidePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height;
    double cardWidth = MediaQuery.of(context).size.width;
    return ContentPlaceholder(context: context, height: cardHeight, width: cardHeight);
  }
}
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {

  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
          length: 4,
          child: new Scaffold(
            body: TabBarView(
                children:
                [
    //             any widget can work very well here <3

                  HomePage(),

                  CategoryListPage(),

                  CheckOutPage(),

                  ProfilePage(),
                ]

            ),


            bottomNavigationBar: Container(
              color: Colors.white,
              child: TabBar(
                  tabs:
                  [
                    Tab(icon: Icon(Icons.home),),
                    Tab(icon: Icon(Icons.category),),
                    Tab(icon: Icon(Icons.shopping_cart),),
                    Tab(icon: Icon(Icons.person),),
                  ]

              ),
            ),
          ));
  }
}
