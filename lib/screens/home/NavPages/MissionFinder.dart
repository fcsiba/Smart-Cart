import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/mission/missionform.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/services/user_api.dart';
import 'package:trash_troopers/widgets/MissionCard.dart';
import 'dart:ui' as ui;

class MissionFinder extends StatefulWidget {
  @override
  _MissionFinderState createState() => _MissionFinderState();
}

// TODO: On Camera move hide the page carousel
class _MissionFinderState extends State<MissionFinder> {
  Completer<GoogleMapController> _controller = Completer();
  PageController _pageController;

  // Fetch all missions into List
  List<Mission> missions = [];
  List<Marker> allMarkers = [];
  List<Marker> _cameraMarker = [];

  LatLng _lastMapPosition = _center;
  LatLng _myMapPosition = _center;
  double _zoomLevel = 18;
  double range = 200;
  int prevPage;
  String currentMarker;

  final _currentPageNotifier = ValueNotifier<int>(0);

  var _currentMapType = MapType.normal;
  static const LatLng _center = const LatLng(24.9418683, 67.1142967);

  BitmapDescriptor myCameraMarkerIcon;
  BitmapDescriptor myMissionMarkerIcon;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  void get initState {
    super.initState;
    // Page conroller - Scroll fixed with viewportFraction: 1,
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8,
    )..addListener(_onScroll);

    // load custom marker icons
    getBytesFromAsset('assets/icons/myCameraMarker.png', 42).then((onValue) {
      myCameraMarkerIcon = BitmapDescriptor.fromBytes(onValue);
    });

    _getGeoLocator();
  }

  _getGeoLocator() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    if (mounted)
      setState(() {
        _myMapPosition =
            LatLng(currentLocation.latitude, currentLocation.longitude);
      });
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      _moveCamera();
    }
  }

  Future<void> _moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    // If coordinates not available, scroll back.
    if (missions.isEmpty) return;
    if (missions[_pageController.page.toInt()] != null) {
      LatLng _lat = LatLng(missions[_pageController.page.toInt()].latitude,
          missions[_pageController.page.toInt()].longitude);

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _lat,
        zoom: _zoomLevel,
        tilt: 45.0,
      )));
    } else {
      _pageController.animateToPage(
        prevPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User instance = Provider.of<User>(context);
    return StreamBuilder(
      stream: MissionApi().fetchMissionsAsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("No Missions");
        } else {
          // Load data from Stream to missions list.
          missions = (snapshot.data as List<Mission>);
          allMarkers.clear();
          missions.forEach((data) {
            allMarkers.add(
              Marker(
                markerId: MarkerId(data.missionID),
                draggable: false,
                infoWindow:
                    InfoWindow(title: data.missionName, snippet: data.address),
                position: LatLng(data.latitude, data.longitude),
                icon: BitmapDescriptor.defaultMarker,
                onTap: () {
                  int gotoPage = missions.indexOf(data);
                  _pageController.animateToPage(
                    gotoPage,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            );
          });
          Set<Circle> circles = Set.from([
            Circle(
              circleId: CircleId('myCircle'),
              strokeColor: Theme.of(context).primaryColorLight,
              fillColor: Theme.of(context).primaryColorLight.withOpacity(0.1),
              strokeWidth: 2,
              center: LatLng(_myMapPosition.latitude, _myMapPosition.longitude),
              radius: range,
            )
          ]);
          return Stack(
            children: <Widget>[
              // Map
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  circles: circles,
                  mapType: _currentMapType,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    // _gotoLocation();
                  },
                  initialCameraPosition: CameraPosition(
                    // target: _myMapPosition,
                    target: LatLng(
                        // issue in first
                        // issue in first
                        // issue in first
                        // 1.234567,1.345678
                        missions.first.latitude,
                        missions.first.longitude),
                    zoom: 16,
                  ),
                  markers: Set.from(allMarkers)..addAll(_cameraMarker),
                  // onTap: _handleTap,
                  onCameraMove: _onCameraMove,
                ),
              ),
              // Mission Carousel
              Positioned(
                bottom: 40,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: PageView.builder(
                      onPageChanged: (int index) {
                        _currentPageNotifier.value = index;
                      },
                      controller: _pageController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Mission mission = snapshot.data[index];
                        bool isAlreadyIn = false;
                        mission.troops?.forEach((s) {
                          if (s.uid == instance.uid) {
                            isAlreadyIn = true;
                          }
                        });

                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (BuildContext context, Widget widget) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = _pageController.page - index;
                              value = (1 - (value.abs() * 0.3) + 0.06)
                                  .clamp(0.0, 1.0);
                            }
                            return Center(
                              child: SizedBox(
                                height: 175.0,
                                width:
                                    Curves.easeInOut.transform(value) * 350.0,
                                child: widget,
                              ),
                            );
                          },
                          child: MissionCard(
                              mission: snapshot.data[index],
                              onTapped: () {
                                _moveCamera();
                              },
                              member: isAlreadyIn,
                              onPressed: isAlreadyIn
                                  ? () async {
                                      if (mission.troops == null)
                                        mission.troops = [];
                                      instance =
                                          await UserApi(uid: instance.uid)
                                              .getUserData();
                                      mission.troops.removeWhere(
                                          (t) => t.email == instance.email);
                                      MissionApi().updateMissionByName(
                                          mission, mission.missionID);
                                      setState(() {});
                                    }
                                  : () async {
                                      if (isAlreadyIn) return null;
                                      if (mission.troops == null)
                                        mission.troops = [];
                                      instance =
                                          await UserApi(uid: instance.uid)
                                              .getUserData();
                                      mission.troops.add(instance);
                                      MissionApi().updateMissionByName(
                                          mission, mission.missionID);
                                      setState(() {});
                                    }),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 20.0,
                child: CirclePageIndicator(
                  size: 6.0,
                  selectedSize: 10.0,
                  selectedDotColor: Theme.of(context).primaryColor,
                  itemCount: snapshot.data.length,
                  currentPageNotifier: _currentPageNotifier,
                ),
              ),
              // Map Options
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      // Create Mission
                      // FloatingActionButton(
                      //   heroTag: null,
                      //   tooltip: 'Create Mission',
                      //   mini: true,
                      //   onPressed: _onAddMarkerButtonPressed,
                      //   materialTapTargetSize: MaterialTapTargetSize.padded,
                      //   backgroundColor: Theme.of(context).primaryColor,
                      //   child: Icon(Icons.add),
                      // ),
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: _onMapTypeButtonPressed,
                        tooltip: 'Change View',
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.map),
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: _gotoLocation,
                        tooltip: 'My Location',
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _gotoLocation() async {
    final GoogleMapController controller = await _controller.future;
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 17.0,
      tilt: 0.0,
      bearing: 0.0,
    )));
  }

  void _handleTap(LatLng point) {
    setState(() {
      // Set Camera location to this point
      _cameraMarker.add(new Marker(
        markerId: MarkerId('cameraMarker'),
        position: point,
        infoWindow: InfoWindow(
          title: 'Create Mission Here',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    });
  }

  void _onAddMarkerButtonPressed() {
    if (_cameraMarker.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Select location on map first!"),
        action: SnackBarAction(
          label: 'HIDE',
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
          },
        ),
      ));
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => MissionForm(
          location: LatLng(
            _cameraMarker.first.position.latitude,
            _cameraMarker.first.position.longitude,
          ),
          oldMission: null,
          editMode: false,
        ),
      ).then((x) => {
            // Clear CameraMarker.
            if (mounted)
              setState(() {
                allMarkers.remove(_cameraMarker);
                _cameraMarker.clear();
              })
          });
    }
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
