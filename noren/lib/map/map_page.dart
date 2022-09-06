import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:noren/map/map_model.dart';
import '../api_key.dart';
import 'package:provider/provider.dart';

const initialPosition = LatLng(37.48800706879053, 139.92963351116);
const _pinkHue = 350.0;
final _placesApiClient = GoogleMapsPlaces(apiKey: googleMapsApiKey);

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  late Stream<QuerySnapshot> _markers;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _markers = FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _markers,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }

          return Stack(
            children: [
              StoreMap(
                documents: snapshot.data!.docs,
                initialPosition: initialPosition,
                mapController: _mapController,
              ),
              StoreCarousel(
                mapController: _mapController,
                documents: snapshot.data!.docs,
              ),
            ],
          );
        },
      ),
    );
  }
}

class StoreCarousel extends StatelessWidget {
  const StoreCarousel({
    super.key,
    required this.documents,
    required this.mapController,
  });

  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: 130,
          child: StoreCarouselList(
            documents: documents,
            mapController: mapController,
          ),
        ),
      ),
    );
  }
}

class StoreCarouselList extends StatelessWidget {
  const StoreCarouselList({
    super.key,
    required this.documents,
    required this.mapController,
  });

  final List<DocumentSnapshot> documents;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 360,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(30)),
              ),
              elevation: 10,
              child: Center(
                child: StoreListTile(
                  document: documents[index],
                  mapController: mapController,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoreListTile extends StatefulWidget {
  const StoreListTile({
    super.key,
    required this.document,
    required this.mapController,
  });

  final DocumentSnapshot document;
  final Completer<GoogleMapController> mapController;

  @override
  State<StatefulWidget> createState() {
    return _StoreListTileState();
  }
}

class _StoreListTileState extends State<StoreListTile> {
  bool isClosed = false;
  // String _placePhotoUrl = '';
  // bool _disposed = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _retrievePlacesDetails();
  // }

  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }

  Future<void> _retrievePlacesDetails() async {
    // final details = await _placesApiClient
    //     .getDetailsByPlaceId(widget.document['name'] as String);
    // if (!_disposed) {
    //   setState(() {
    //     _placePhotoUrl = _placesApiClient.buildPhotoUrl(
    //       photoReference: details.result.photos[0].photoReference,
    //       maxHeight: 300,
    //     );
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapModel>(
      create: (_) => MapModel()..fetchUser(),
      child: Consumer<MapModel>(builder: (context, model, child) {
        return ListTile(
          leading: Text(
            widget.document['isClosed'] == false ? 'Closed❌' : 'Open🟢',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // trailing: IconButton(
          //   onPressed: () {
          //     print('pressed');
          //   },
          //   icon: Icon(Icons.menu),
          // ),
          dense: false,
          title: Text(widget.document['name'] as String),
          subtitle: Text(widget.document['message'] as String),
          isThreeLine: true,
          onTap: () async {
            final controller = await widget.mapController.future;
            await controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                      widget.document['location'].latitude as double,
                      widget.document['location'].longitude as double,
                    ),
                    zoom: 16,
                    tilt: 45.0),
              ),
            );
          },
        );
      }),
    );
  }
}

class StoreMap extends StatelessWidget {
  const StoreMap({
    super.key,
    required this.documents,
    required this.initialPosition,
    required this.mapController,
  });

  final List<DocumentSnapshot> documents;
  final LatLng initialPosition;
  final Completer<GoogleMapController> mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // zoomControlsEnabled: true,
      // zoomGesturesEnabled: true,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14,
      ),
      markers: documents
          .map((document) => Marker(
                markerId: MarkerId(document['name'] as String),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(
                  document['location'].latitude as double,
                  document['location'].longitude as double,
                ),
                infoWindow: InfoWindow(
                  title: document['name'] as String?,
                  snippet: document['message'] as String?,
                ),
              ))
          .toSet(),
      onMapCreated: (mapController) {
        this.mapController.complete(mapController);
      },
    );
  }
}
