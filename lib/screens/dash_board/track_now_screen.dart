import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:subjiwala/View%20Models/CustomViewModel.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';

class TrackNowScreen extends StatefulWidget {
  final String vendorName;
  final int index;
  final String id;

  const TrackNowScreen({Key? key, required this.vendorName, required this.index, required this.id}) : super(key: key);

  @override
  State<TrackNowScreen> createState() => _TrackNowScreenState();
}

class _TrackNowScreenState extends State<TrackNowScreen> {
  Timer? timer;
  bool isLoad = false;

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Uint8List? markIcons;

  loadData() async {
    CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
    markIcons = await getImages("assets/pin.png", 150);
    await state.getLocation(widget.id, widget.index);
    isLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    isLoad = true;
    loadData();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      CustomViewModel state = Provider.of<CustomViewModel>(context, listen: false);
      await state.getLocation(widget.id, widget.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 3, right: 15, left: 10, bottom: 3),
            child: Row(
              children: [
                IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: AppColors.white)),
                const SizedBox(width: 5),
                Text(
                  "Vendor Location",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.048,
                      letterSpacing: 1,
                      wordSpacing: 1,
                      color: AppColors.white),
                ),
                const Spacer(),
                IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        isLoad = true;
                      });
                      loadData();
                    },
                    icon: const Icon(Icons.refresh, color: AppColors.white)),
              ],
            ),
          ),
          Consumer<CustomViewModel>(builder: (context, state, child) {
            LatLng latLng = LatLng(double.parse(state.vendorList[widget.index].userLat ?? "0.0"),
                double.parse(state.vendorList[widget.index].userLong ?? "0.0"));
            return Expanded(
              child: isLoad
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: latLng, zoom: 18),
                      myLocationEnabled: true,
                      mapToolbarEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () {
                            controller.showMarkerInfoWindow(const MarkerId("1"));
                          },
                        );
                      },
                      markers: <Marker>{
                        Marker(
                          markerId: const MarkerId("1"),
                          icon: BitmapDescriptor.fromBytes(markIcons!),
                          position: latLng,
                          visible: true,
                          infoWindow: InfoWindow(
                            title: widget.vendorName,
                          ),
                        )
                      },
                    ),
            );
          }),
          Container(height: MediaQuery.of(context).padding.bottom, color: AppColors.primary)
        ],
      ),
    );
  }
}
