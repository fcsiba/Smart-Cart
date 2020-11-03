import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trash_troopers/models/offer.dart';
import 'package:trash_troopers/services/helper.dart';
import 'package:trash_troopers/services/offer_api.dart';
import 'package:trash_troopers/widgets/OfferCard.dart';

AnimationController _controller;
Animation<double> _animation;

class OfferStore extends StatefulWidget {
  const OfferStore({Key key}) : super(key: key);

  @override
  _OfferStoreState createState() => _OfferStoreState();
}

class _OfferStoreState extends State<OfferStore> with TickerProviderStateMixin {
  int _till = 1540; // Random().nextInt(1000);

  @override
  void get initState {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5200),
    );
    _animation = _controller;
    super.initState;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // _till += rng.nextInt(20) + 0.3;
      _animation = new Tween<double>(
        begin: _animation.value,
        end: _till + .0,
      ).animate(new CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        parent: _controller,
      ));
    });
    _controller.forward(from: 0.0);

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          elevation: 10.0,
          backgroundColor: Colors.white,
          pinned: false,
          floating: false,
          expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 16),
            title: Text(
              'Rewards Store',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Quicksand'),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.history,
                color: Colors.amber,
              ),
              tooltip: 'Show Redeem History',
              onPressed: () {/* ... */},
            ),
          ],
        ),
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: MyDynamicHeader(),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    // addDummyOffers(),
                    offerListBuilder('Food'),
                    offerListBuilder('Food'),
                    offerListBuilder('Food'),
                    ActionChip(
                      onPressed: () {},
                      avatar: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      label: Text("Redeem Prizes! Coming Soon!",
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget addDummyOffers() {
  return Center(
    child: RaisedButton(
      child: Text('Add Offer'),
      onPressed: () {
        String offerId = Helper.generateHash(16);
        Offer offerF = Offer(
          id: offerId,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          vendor: 'KFC',
          detail: "Buy 1 Get 1 Combo",
          name: "Buy 1 Get 1 Combo",
          points: 5000,
          offerCode: "Xj786Ry",
          type: 'food',
          image:
              "https://firebasestorage.googleapis.com/v0/b/trash-troopers.appspot.com/o/offers%2Ffood.jpg?alt=media&token=67700304-8881-46cc-8faa-4f4f9b14dd33",
          creatorId: null,
        );

        Offer offerT = Offer(
          id: offerId,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          vendor: 'Telenor',
          detail: "50rs. Credit",
          name: "Get 50rs. Credit",
          points: 1000,
          offerCode: "Xj786Ry",
          type: 'top-up',
          image:
              "https://firebasestorage.googleapis.com/v0/b/trash-troopers.appspot.com/o/offers%2Ftopup.jpg?alt=media&token=d29bb764-75c5-4e1f-a8cf-36a3e3f61ee5",
          creatorId: null,
        );

        OfferApi().addOffer(offerT);
        OfferApi().addOffer(offerF);
      },
    ),
  );
}

Widget offerListBuilder(String type) {
  double cardHeight = 200;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0),
        child: Text(
          '${type.toUpperCase()} OFFERS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'QuickSand',
            color: Colors.black,
          ),
        ),
      ),
      FutureBuilder<List<Offer>>(
        future: OfferApi().fetchOffersByType(type),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          else if (snapshot.hasData) {
            return Container(
              child: Container(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OfferCard(
                      offer: snapshot.data[index],
                      onTapped: () {
                        // Open Offer page or Modal
                      },
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    ],
  );
}

class MyDynamicHeader extends SliverPersistentHeaderDelegate {
  int index = 0;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: SafeArea(
          child: Card(
            margin: EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white,
            elevation: 8.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorLight
                  ],
                ),
              ),
              child: new AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          new Text(
                            _animation.value.toStringAsFixed(0),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'QuickSand',
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            'Points',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'QuickSand',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // ActionChip(
                      //   onPressed: () {},
                      //   avatar: Icon(
                      //     Icons.attach_money,
                      //     color: Colors.white,
                      //   ),
                      //   label: Text("View Points",
                      //       style: TextStyle(color: Colors.white)),
                      //   backgroundColor: Colors.orangeAccent,
                      // ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 150.0;

  @override
  double get minExtent => 80.0;
}
