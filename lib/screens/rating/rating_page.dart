import 'package:cached_network_image/cached_network_image.dart';
import 'package:rentreerapide/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rentreerapide/helpers/consts.dart';
import 'package:rentreerapide/models/product.dart';

import 'package:rentreerapide/screens/rating/rating_dialog.dart';

class RatingPage extends StatefulWidget {
  final Product product;

  RatingPage(this.product);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double rating = 0.0;
  List<int> ratings = [2, 1, 5, 2, 4, 3];
  List ratings2 = [
    {'username' : 'billy holand1', 'value':3, 'time':'10 am, Via IOS', 'picture':'', 'comment':'great', 'likes':30},
    {'username' : 'billy holand2', 'value':2, 'time':'10 am, Via IOS', 'picture':'', 'comment':'cool', 'likes':30},
    {'username' : 'billy holan3', 'value':4, 'time':'10 am, Via IOS', 'picture':'', 'comment':'nice', 'likes':30},
    {'username' : 'billy holand4', 'value':1, 'time':'10 am, Via IOS', 'picture':'', 'comment':'well done', 'likes':30},
    {'username' : 'billy holand5', 'value':5, 'time':'10 am, Via IOS', 'picture':'', 'comment':'great', 'likes':30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Image.asset('assets/icons/comment.png'),
              onPressed: () {
                showDialog(
                    context: context,
                    child: Dialog(
                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: RatingDialog(),
                    ));
              },
              color: Colors.black,
            ),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (b, constraints) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(3.6),
                            height: 162,
                            width: 162,

                            decoration: BoxDecoration(
                              color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: shadow,
                                border: Border.all(width: 8.0, color: Colors.white)
                            ),
                           
                            child: MaterialButton(
                              shape: CircleBorder(),
                              // disabledColor: Colors.red,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                                errorWidget: (context, url , error) => loadingImageError,
                                imageUrl: '${widget.product.image}',
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 72.0, vertical: 16.0),
                            child: Text('${widget.product.name}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                '4.8',
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                FlutterRatingBar(
                     // borderColor: Color(0xffFF8993),
                     // fillColor: Color(0xffFF8993),
                                  ignoreGestures: true,
                                  itemSize: 20,
                                  allowHalfRating: true,
                                  initialRating: 4.2,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  fullRatingWidget: Icon(
                                    Icons.star,
                                    color: Color(0xffFF8993),
                                    size: 20,
                                  ),
                                  noRatingWidget: Icon(Icons.star_border,
                                      color: Color(0xffFF8993), size: 20),
                                  onRatingUpdate: (value) {
                                    setState(() {
                                      rating = value;
                                    });
                                    // print(value);
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text('par 25 personnes'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Align(
                            alignment: Alignment(-1, 0),
                            child: Text('Note Recente')),
                      ),
                      Column(
                        children: <Widget>[
                          ...ratings2
                              .map((val) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5.0))),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: CircleAvatar(
                                          maxRadius: 14,
                                          backgroundImage:
                                              AssetImage('assets/background.jpg'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '${val['username']}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '10 am, Via iOS',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                              child: FlutterRatingBar(
//                                borderColor: Color(0xffFF8993),
//                                fillColor: Color(0xffFF8993),
                                                ignoreGestures: true,
                                                itemSize: 20,
                                                allowHalfRating: true,
                                                initialRating: val['value'].toDouble(),
                                                itemPadding: EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                fullRatingWidget: Icon(
                                                  Icons.star,
                                                  color: Color(0xffFF8993),
                                                  size: 14,
                                                ),
                                                noRatingWidget: Icon(
                                                    Icons.star_border,
                                                    color: Color(0xffFF8993),
                                                    size: 14),
                                                onRatingUpdate: (value) {
                                                  setState(() {
                                                    rating = value;
                                                  });
                                                  // print(value);
                                                },
                                              ),
                                            ),
                                            Text(
                                              '${val['comment']}',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '${val['likes']} likes',
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontSize: 10.0),
                                                  ),
                                                  Text(
                                                    '1 Comment',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10.0),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )))
                              .toList()
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
