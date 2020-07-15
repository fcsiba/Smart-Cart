import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trash_troopers/models/offer.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final Function onTapped;
  const OfferCard({Key key, this.offer, this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: InkWell(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Comming Soon!"),
            action: SnackBarAction(
              label: 'HIDE',
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            ),
          ));
        },
        child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image
              Container(
                width: 150,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
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

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      // String detail;
                      // String vendor;
                      // String offerCode;
                      // String createdAt;
                      // String updatedAt;
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
