import 'package:carousel_slider/carousel_slider.dart';
import 'package:content_placeholder/content_placeholder.dart';
import 'package:rentreerapide/models/category.dart';
import 'package:rentreerapide/models/product.dart';
import 'package:rentreerapide/screens/category/category_list_page.dart';
import 'package:rentreerapide/screens/main/components/category_card.dart';
import 'package:rentreerapide/screens/notifications_page.dart';
import 'package:rentreerapide/screens/product/components/product_card.dart';
import 'package:rentreerapide/screens/profile_page.dart';
import 'package:rentreerapide/screens/search_page.dart';
import 'package:rentreerapide/screens/shop/check_out_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:loadmore/loadmore.dart';
import 'components/custom_bottom_bar.dart';
import 'components/special_product_list.dart';
import 'components/tab_view.dart';

class SlidePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height;
    double cardWidth = MediaQuery.of(context).size.width;
    return ContentPlaceholder(context: context, height: cardHeight, width: cardHeight);
  }
}

List<String> timelines  = ['Populaires', 'Promos', 'Deals'];
String selectedTimeline = 'Populaire';
Color orange = Colors.orange;

List<Product> products = [Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''),];
List<Product> featured_products = [Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''),];
List<Product> promo_products = [Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''),];
List<Product> deal_products = [Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''), Product('image_placeholder', '', '', ''),];
List<Widget> slides = [SlidePlaceHolder(), SlidePlaceHolder(), SlidePlaceHolder(),];
List<Category> best_categories = [];
List<Tab> tbs = [Tab(text: 'category'), Tab(text: 'category'), Tab(text: 'category'), Tab(text: 'category'), Tab(text: 'category'),];

dynamic standart_products = [];

List<Category> categories = [
  Category(
    Color(0xffFCE183),
    Color(0xffF68D7F),
    'placeholder',
    'assets/jeans_5.png',
  ),
  Category(
    Color(0xffF749A2),
    Color(0xffFF7375),
    'placeholder',
    'assets/jeans_5.png',
  ),
  Category(
    Color(0xff00E9DA),
    Color(0xff5189EA),
    'placeholder',
    'assets/jeans_5.png',
  ),
  Category(
    Color(0xff00E9DA),
    Color(0xff5189EA),
    'placeholder',
    'assets/jeans_5.png',
  ),
  Category(
    Color(0xff00E9DA),
    Color(0xff5189EA),
    'placeholder',
    'assets/jeans_5.png',
  ),
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int get count => list.length;
  List<String> list = List<String>.generate(100, (i) => "Item $i");
  SwiperController swiperController;
  TabController tabController;
  TabController bottomTabController;
  TextEditingController search_controller;
  bool product_placeholder = true;
  int _current = 0;
  int max_cat_length = 5;

  ProductFromPage prpg;
  int current_page = 1;
  int total_page   = 5;
  List<Product> product_from_pages;
  bool isLoading = false;

  _HomePageState(){
    //init_slides
    getSlides().then((data)=>setState((){
      slides = data;
    }));

    getProducts().then((data)=>setState((){
      featured_products = [];
      var fp = data['featured_products'];
      fp.forEach((element){
        featured_products.add(Product.fomJson(element));
      });

      promo_products = [];
      var pp = data['promotion_products'];
      pp.forEach((element){
        promo_products.add(Product.fomJson(element));
      });

      selectedTimeline = timelines[0];
      products = featured_products;
      product_placeholder = true;
      categories = [];
      tbs = [];
      var pc = data['product_categories'];

      standart_products = data['standart_products'];

      int added_tab = 0;
      pc.forEach((element){
        categories.add(Category.fromJson(element));
        if(added_tab < max_cat_length){
          added_tab++;
          tbs.add(Tab(text: element['name']));
          best_categories.add(Category.fromJson(element));
        }
      });
    }));

    print('---------------- here ok ----------------------');
    getProductsByPage(current_page.toString()).then((data) => setState((){
      print('step1 ok');
      prpg = data;
      product_from_pages = prpg.products;
      total_page = prpg.total_page;
    }));
  }
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: max_cat_length, vsync: this);
    bottomTabController = TabController(length:4, vsync: this);
  }


  Future _loadData() async {
    int pg = current_page + 1;
    ProductFromPage prp  = await getProductsByPage(pg.toString());
    print("load more");
    setState(() {
      product_from_pages.addAll(prp.products);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //APPBAR === SEARCH BAR AND NOTIFICATION=====
    Widget appBar = Container(
      color: Colors.red,
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      margin: EdgeInsets.only(top:24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsPage())),
              icon: Icon(Icons.notifications , color: Colors.white,)),
          Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchPage())),
                child: Container(
                  height: 40.0,
                  child: TextField(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchPage())),
                    controller: search_controller,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    readOnly: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(4.5, 6.3, 4.5, 6.3),
                        hintText: 'Rechercher',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        suffixIcon: Icon(Icons.search , color: Colors.black,),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true),
                  ),
                ),
              )
          ),

          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NotificationsPage())),
              icon: Icon(Icons.shopping_cart , color: Colors.white,)),

        ],
      ),
    );
    //POPULAIRES --- PROMOS --- DEALS
    Widget topHeader = Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 9.0 , bottom: 9.0),
        child: Container(
          padding: EdgeInsets.only(top: 3.6 , bottom: 3.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                child: MaterialButton(
                    padding: EdgeInsets.all(1.0),
                    onPressed: () {
                      setState(() {
                        selectedTimeline = timelines[0];
                        products = featured_products;
                      });
                    },
                    child: Column(
                      children: [
                        RawMaterialButton(
                          // onPressed: (){},
                          constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
                          child:
                          Icon(Icons.star, color: Colors.white , size: 30,),
                          elevation: 0.0,
                          shape: CircleBorder(),
                          fillColor: timelines[0] == selectedTimeline ? Colors.deepOrange : orange,

                        ),

                        Text(
                          timelines[0],
                          style: TextStyle(
                              fontSize: timelines[0] == selectedTimeline ? 15 : 14,
                              color: Colors.black),
                        ),
                      ],
                    )
                ),
              ),

              Flexible(
                child: MaterialButton(
                    padding: EdgeInsets.all(1.0),
                    onPressed: () {
                      setState(() {
                        selectedTimeline = timelines[1];
                        products = promo_products;
                      });
                    },
                    child: Column(
                      children: [
                        RawMaterialButton(
                          // onPressed: (){},
                          constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
                          child:
                          Icon(Icons.card_giftcard, color: Colors.white , size: 30.0,),
                          elevation: 0.0,
                          shape: CircleBorder(),
                          fillColor: timelines[1] == selectedTimeline ? Colors.deepOrange : orange,

                        ),

                        Text(
                          timelines[1],
                          style: TextStyle(
                              fontSize: timelines[1] == selectedTimeline ? 15 : 14,
                              color: Colors.black),
                        ),
                      ],
                    )
                ),
              ),

              Flexible(
                child: MaterialButton(
                    padding: EdgeInsets.all(1.0),
                    onPressed: () {
                      setState(() {
                        selectedTimeline = timelines[2];
                        products = deal_products;
                      });
                    },
                    child: Column(
                      children: [
                        RawMaterialButton(
                          // onPressed: (){},
                          constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
                          child:
                          Icon(Icons.style, color: Colors.white , size: 30.0,),
                          elevation: 0.0,
                          shape: CircleBorder(),
                          fillColor: timelines[2] == selectedTimeline ? Colors.deepOrange : Colors.lightBlue,

                        ),

                        Text(
                          timelines[2],
                          style: TextStyle(
                              fontSize: timelines[2] == selectedTimeline ? 15 : 14,
                              color: Colors.black),
                        ),
                      ],
                    )
                ),
              ),


            ],
          ),
        ));
    //PRODUCT_BY_CATEGORIES
    Widget tabBar = TabBar(
      tabs: tbs,
      labelStyle: TextStyle(fontSize: 16.0 , color: Colors.white , fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.0,
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
      isScrollable: true,
      controller: tabController,
      // indicatorColor: Colors.orange,
      indicator: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.all(Radius.circular(3.6)),
      ),
    );
    Widget slide = Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.fromLTRB(0.0, 3.6, 0.0, 3.6),
      color: Colors.white,
      child: Column(children: [
        CarouselSlider(
          items: slides,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              aspectRatio: 2.8,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        //DOTS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: slides.map((url) {
            int index = slides.indexOf(url);
            return Container(
              width: 6.0,
              height: 6.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Colors.orange
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ]),
    );
    return Container(
      color: Color(0xFFF5F5F5),
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(child: appBar),
                SliverToBoxAdapter(child: slide),
                SliverToBoxAdapter(child: topHeader),
                SliverToBoxAdapter(
                  child: SpecialProductList(
                    products: products,
                  ),
                ),
                SliverToBoxAdapter(child: Categories(categories)),

                SliverToBoxAdapter(
                  child: category_product(
                      categories: best_categories,
                      standart_products: standart_products
                  ),
                )

              ];
            },

            body:(product_from_pages != null) ?Column(
              children: <Widget>[
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        if((current_page<=total_page)){
                          _loadData();
                          // start loading data
                          setState(() {
                            isLoading = true;
                          });
                        }
                      }
                      return true;
                    },
                    child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 0.9,
                              mainAxisSpacing: 1.9
                            ),
                            itemCount: product_from_pages.length,
                            itemBuilder: (context, index){
                              return ProductCard(product: product_from_pages[index]);
                            }
                          )

                  ),
                ),
                Container(
                  height: isLoading ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ],
            )
            :Container()
          )
          ),
          ),
    );
  }
}
