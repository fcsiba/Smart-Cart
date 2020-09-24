import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/api.dart';

class MissionApi {
  Api _missionApi = Api('missions');

  Future<List<Mission>> fetchMissions() async {
    var result = await _missionApi.getDataCollection();
    List<Mission> missions =
        result.documents.map((doc) => Mission.fromJson(doc.data)).toList();
    return missions;
  }

  Stream<List<Mission>> fetchMissionsAsStream() {
    return _missionApi.db
        .collection('missions')
        .orderBy('createdAt')
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => Mission.fromJson(doc.data)).toList());
  }

  Stream<List<Mission>> fetchMissionsAsStreamByUser(User user) {
    return _missionApi.streamDataCollection().map((list) => list.documents
        .map((doc) => Mission.fromJson(doc.data))
        .where((m) => m.hasUser(user))
        .toList());
  }

  Stream<List<Mission>> fetchMissionsAsStreamByLeader(User user) {
    return _missionApi.streamDataCollection().map((list) => list.documents
        .map((doc) => Mission.fromJson(doc.data))
        .where((m) => m.isLeader(user))
        .toList());
  }
  
  Stream<List<MissionFeed>> fetchMissionFeedsAsStream(Mission myMission) {
    return this
        ._missionApi
        .db
        .collection("missions")
        .document(myMission.docID)
        .collection("missionFeeds")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map((list) {
      return list.documents.map((doc) {
        MissionFeed m = MissionFeed();
        m.description = doc.data["description"];
        m.dateTime = DateTime.parse(doc.data["dateTime"]);
        m.user = User.fromJson(doc.data["user"]);
        // m.user.name = (doc.data["user"] as Map)["name"] as String ?? "Alpha";
        return m;
      }).toList();
    });
  }

  Future<double> getScoreFromAllRatings(User user) async {
    // TODO: Very Inefficient method. Fix Later

    double sum = 0;
    _missionApi.streamDataCollection().map((list) => list.documents
        .map((doc) => Mission.fromJson(doc.data))
        .where((m) => m.hasUser(user)).forEach(
       (m) {
          this
        ._missionApi
        .db
        .collection("missions")
        .document(m.docID)
                .collection("missionRatings")
        .snapshots()
        .forEach((docs) {
          docs.documents.forEach( (doc) =>
           sum += doc.data["to"] == user.uid ? doc.data["rating"] : 0);
        });
        }
    ));
    return sum;
  }

  void addMissionRating(Mission mission, String from, String to, double rating) async {
    final collection =  this
        ._missionApi
        .db
        .collection("missions")
        .document(mission.docID)
        .collection("missionRatings");
    // TODO: Upsert Form , should have unique id
    collection.snapshots().forEach( (list) {
      list.documents.removeWhere( (item) => 
         item["from"] == from && item["to"] == to
      );
    });

     collection
        .add({
      "from": from,
      "to": to,
      "rating": rating
    }).catchError((e) => print(e));
  }

  void addMissionFeed(Mission mission, MissionFeed myFeed) async {
    await this
        ._missionApi
        .db
        .collection("missions")
        .document(mission.docID)
        .collection("missionFeeds")
        .add({
      "description": myFeed.description,
      "dateTime": myFeed.dateTime.toIso8601String(),
      "user": myFeed.user.toJson()
    }).catchError((e) => print(e));
  }

  Future<Mission> getMissionById(String id) async {
    var doc = await _missionApi.getDocumentById(id);
    return Mission.fromJson(doc.data);
  }

  Future removeMission(String id) async {
    await _missionApi.removeDocument(id);
    return;
  }

  Future updateMission(Mission data, String id) async {
    await _missionApi.updateDocument(data.toJson(), id);
    return;
  }

  Future updateMissionByName(Mission data, String name) async {
    _missionApi.db
        .collection('missions')
        .where('missionID', isEqualTo: data.missionID)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot) {
        documentSnapshot.reference.updateData(data.toJson());
      });
    });
  }

  Future addMission(Mission data) async {
    var result = await _missionApi.addDocument(data.toJson());
    data.docID = result.documentID;
    this.updateMissionByName(data, data.missionID);
    return;
  }
}
