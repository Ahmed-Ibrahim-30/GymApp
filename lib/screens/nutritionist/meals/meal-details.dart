import 'package:flutter/material.dart';
import 'package:gym_project/widget/grid_view_card.dart';

class MealDetailsScreen extends StatelessWidget {
  final _meal = {
    'id': 1,
    'title': "Set 1",
    'nutririonist': 'Amr Fatouh',
    'items': [
      {
        'title': 'Apple',
        'image':
            'https://arabic.bestapples.com/wp-content/uploads/2015/10/gala-249x300.jpg',
        'calories': 40,
        'level': 'green',
        'creator': 'Amr Fatouh',
        'quantity': 1
      },
      {
        'title': '250gm Chicken',
        'image':
            'https://cdn.shopify.com/s/files/1/0476/0115/6257/products/ChickenPopcorn_530x@2x.jpg?v=1618080367',
        'calories': 300,
        'level': 'red',
        'creator': 'Amr Fatouh',
        'quantity': 2
      },
      {
        'title': 'Carrot',
        'image': 'https://www.owimio.com/wp-content/uploads/2021/02/carrot.jpg',
        'calories': 20,
        'level': 'green',
        'creator': 'Amr Fatouh',
        'quantity': 1
      },
      {
        'title': 'Banana',
        'image': 'https://thumbs.dreamstime.com/b/ripe-bannana-13802636.jpg',
        'calories': 60,
        'level': 'green',
        'creator': 'Amr Fatouh',
        'quantity': 1
      },
      {
        'title': '250gm of rice',
        'image':
            'https://food.fnr.sndimg.com/content/dam/images/food/fullset/2020/06/23/0/FNK_Perfect-Long-Grain-White-Rice-H_s4x3.jpg.rend.hgtvcom.616.462.suffix/1592939598668.jpeg',
        'calories': 150,
        'level': 'red',
        'creator': 'Amr Fatouh',
        'quantity': 3
      },
      {
        'title': '50gm of cheese',
        'image':
            'https://www.usdairy.com/optimize/getmedia/6ab03180-cc90-4a03-a339-13b540ecc8a5/american.jpg.jpg.aspx?format=webp',
        'calories': 80,
        'level': 'yellow',
        'creator': 'Amr Fatouh',
        'quantity': 1
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                child: Image.network(
                  "https://thumbs.dreamstime.com/b/fresh-fast-food-generic-restaurant-trays-prepared-quick-meal-photographed-angle-above-right-55110010.jpg",
                  fit: BoxFit.fill,
                ),
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10),
                child: Text(
                  _meal['title'],
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Exercises",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'assets/fonts/Changa-Bold.ttf',
                  ),
                ),
              ),
              CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(26.0),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: <Widget>[
                        for (Map<String, Object> item in _meal['items'])
                          GridViewCard(
                              item['image'],
                              item['title'],
                              'Cals: ${item['calories']}',
                              'Quantity: ${item['quantity']}',
                              'Created By: ${item['nutritionist']}',
                              '',
                            context,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
