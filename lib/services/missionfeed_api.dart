import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/services/api.dart';

class MissionFeedApi {
  Api _missionFeedApi = Api('missionfeeds');

  Future<List<MissionFeed>> fetchMissionFeeds() async {
    var result = await _missionFeedApi.getDataCollection();
    List<MissionFeed> missionFeeds =
        result.documents.map((doc) => MissionFeed.fromJson(doc.data)).toList();
    return missionFeeds;
  }

  Stream<List<MissionFeed>> fetchMissionFeedsAsStream() {
    return _missionFeedApi.streamDataCollection().map((list) =>
        list.documents.map((doc) => MissionFeed.fromJson(doc.data)).toList());
  }

  Future<MissionFeed> getMissionFeedById(String id) async {
    var doc = await _missionFeedApi.getDocumentById(id);
    return MissionFeed.fromJson(doc.data);
  }

  Future removeMissionFeed(String id) async {
    await _missionFeedApi.removeDocument(id);
    return;
  }

  Future updateMissionFeed(MissionFeed data, String id) async {
    await _missionFeedApi.updateDocument(data.toJson(), id);
    return;
  }

  Future addMissionFeed(MissionFeed data) async {
    var result = await _missionFeedApi.addDocument(data.toJson());
    return;
  }
}
