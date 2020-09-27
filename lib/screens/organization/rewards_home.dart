import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:trash_troopers/models/offer.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/offer_api.dart';

import 'offer_form.dart';

class MyOrgRewards extends StatefulWidget {
  final User user;
  const MyOrgRewards({Key key, this.user}) : super(key: key);

  @override
  _MyOrgRewardsState createState() => _MyOrgRewardsState();
}

class _MyOrgRewardsState extends State<MyOrgRewards> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Offer> offers;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add offer code here!
          // Alert with offer input.
          showDialog(
            context: context,
            builder: (BuildContext context) => OfferForm(
              oldOffer: null,
              editMode: false,
            ),
          ).then((value) => () {
                Navigator.of(context).pop();
                setState(() {});
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        title: Text(
          "${this.widget.user.name} Rewards",
        ),
      ),
      body: StreamBuilder(
          stream: OfferApi().fetchOffersByUidAsStream(this.widget.user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: Text('No Organization Rewards.'));
            else {
              print(this.widget.user.uid);
              print(snapshot.data.length);
              offers = (snapshot.data as List<Offer>);
              print(offers.toList());

              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OfferEditCard(
                      offer: snapshot.data[index],
                      onTapped: () {
                        // Open Offer page or Modal
                      },
                    );
                  },
                ),
              );
            }
          }),
    );
  }
}

class OfferEditCard extends StatelessWidget {
  final Offer offer;
  final Function onTapped;
  const OfferEditCard({Key key, this.offer, this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //  Image
              Container(
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  child: Center(
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: offer.image,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${offer.name}',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        Text(
                          'by ${offer.vendor}',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),

                        Text(
                          '${offer.points}  Points',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'QuickSand',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        Text(
                          new DateFormat.yMMMd()
                              .format(offer.updatedAt.toDate())
                              .toString(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'QuickSand',
                            color: Colors.black87,
                          ),
                        ),
                        // String detail;
                        // String vendor;
                        // String offerCode;
                        // String createdAt;
                        // String updatedAt;
                      ],
                    ),

                    // Edit/Delete buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Edit offer here
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => OfferForm(
                                oldOffer: offer,
                                editMode: true,
                              ),
                            );
                          },
                          icon: new Icon(
                            Icons.edit,
                            color: Colors.black54,
                            size: 36,
                          ),
                          tooltip: "Edit Offer",
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            // Delete offer here
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                      "Are you sure to delete ${offer.name}?"),
                                  actions: [
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () {},
                                    ),
                                    FlatButton(
                                      child: Text("DELETE"),
                                      onPressed: () {
                                        OfferApi().removeOffer(offer.docID);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: new Icon(
                            Icons.delete,
                            color: Colors.red[300],
                            size: 36,
                          ),
                          tooltip: "Delete Offer",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
