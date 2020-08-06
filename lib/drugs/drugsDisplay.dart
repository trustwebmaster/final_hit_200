// import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../pharmacies/locations.dart';
import '../pharmacies/pharmacy_services.dart';

class DrugDisplay extends StatefulWidget {
  DrugDisplay() : super();

  final String title = 'Road Angels';

  @override
  DrugDisplayState createState() => DrugDisplayState();
}

class DrugDisplayState extends State<DrugDisplay> {
  Size deviceSize;
  List<Pharmacy> _pharmacies;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _pharmacies = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _getPharmacies();
  }

  void _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  void _getPharmacies() {
    PharmacyService.getPharmacies().then((pharmacies) {
      setState(() {
        _pharmacies = pharmacies;
      });
      _showProgress(widget.title);
      print("Length ${pharmacies.length}");
    });
  }

  void _showDialog(Pharmacy pharmacy) {
    final marker = Marker(
      markerId: MarkerId(pharmacy.name),
      position: LatLng(double.parse(pharmacy.lat), double.parse(pharmacy.long)),
      infoWindow: InfoWindow(
        title: pharmacy.name,
        snippet: pharmacy.address,
      ),
    );
    setState(() {
      markers[MarkerId(pharmacy.name)] = marker;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Road Angel Location"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(-17.824858, 31.053028),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget descStack(Pharmacy pharmacy) => Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Container(
          decoration: BoxDecoration(color: Colors.blue[900].withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    pharmacy.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _dataBody() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ListView.builder(
        itemBuilder: (context, position) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('$position'),
              ),
              title: Text(_pharmacies[position].name),
              subtitle: Text(_pharmacies[position].address),
              trailing: Icon(
                Icons.directions,
                color: Colors.blue[900],
                size: 28.0,
              ),
              onTap: () => _showDialog(_pharmacies[position]),
            ),
          );
        },
        itemCount: _pharmacies.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Center(
          child: Text(
            _titleProgress,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {
              _getPharmacies();
            },
          )
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/pills.jpg',
              ),
            ),
          ),
          height: deviceSize.height,
        ),
        Container(
          height: deviceSize.height,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.blue[900].withOpacity(0.5),
                    Colors.blue[900].withOpacity(0.9),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(),
              Expanded(
                child: _dataBody(),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
