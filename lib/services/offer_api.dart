import 'package:trash_troopers/models/offer.dart';
import 'package:trash_troopers/services/api.dart';

class OfferApi {
  Api _offerApi = Api('offers');

  Future<List<Offer>> fetchOffers() async {
    var result = await _offerApi.getDataCollection();
    List<Offer> offers =
        result.documents.map((doc) => Offer.fromJson(doc.data)).toList();
    return offers;
  }

  Future<List<Offer>> fetchOffersByType(String type) async {
    var result = await _offerApi.db
        .collection('offers')
        .where('type', isEqualTo: type)
        .getDocuments();
        
    List<Offer> offers =
        result.documents.map((doc) => Offer.fromJson(doc.data)).toList();
    return offers;
  }

  Stream<List<Offer>> fetchOffersAsStream() {
    return _offerApi.streamDataCollection().map((list) =>
        list.documents.map((doc) => Offer.fromJson(doc.data)).toList());
  }

  Future<Offer> getOfferById(String id) async {
    var doc = await _offerApi.getDocumentById(id);
    return Offer.fromJson(doc.data);
  }

  Future removeOffer(String id) async {
    await _offerApi.removeDocument(id);
    return;
  }

  Future updateOffer(Offer data, String id) async {
    await _offerApi.updateDocument(data.toJson(), id);
    return;
  }

  Future updateOfferByName(Offer data, String name) async {
    _offerApi.db
        .collection('offers')
        .where('id', isEqualTo: data.id)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) {
        documentSnapshot.reference.updateData(data.toJson());
      });
    });
  }

  Future addOffer(Offer data) async {
    await _offerApi.addDocument(data.toJson());
    return;
  }
  
}
