part of '../pages.dart';

class MapaUpcPage extends GetView<MapaUpcController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapaUpcController>(
      builder: (_) => getContenido(context),
    );
  }

  warningWidgetGetX() {
    controller.connectionStatusController();
    return Obx(() {
      return Visibility(
          visible: controller.status.value != ConnectionStatus.online,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                color: Colors.red,
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off),
                    SizedBox(width: 5),
                    Text(
                      'No tiene Conexión a Internet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }

  getContenido(BuildContext context) {
    final responsive = ResponsiveUtil();
    return Scaffold(
      bottomNavigationBar: bannerInferior(responsive),
      appBar: getAppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
              child: SizedBox(
                height: responsive.alto,
                child: Stack(
                  children: [
                    Obx(() =>
                    AppConfig.ubicacion.value.latitude != 0.0
                        ? GestureDetector(
                      child:
                      Obx(() =>   FlutterMap(
                        mapController: controller.mapController,
                        options: MapOptions(
                            initialCenter: AppConfig.ubicacion.value,
                            initialZoom: 16),
                        children: [
                          TileLayer(
                            urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            minZoom: controller.minZoom,
                            maxZoom: controller.maxZoom,
                            userAgentPackageName: 'upcbolsillo',
                          ),
                      MarkerLayer(
                            markers: [
                            AppConfig.ubicacion.value.latitude!=0.0?markerPersona():markerPersonaVacio(),
                            ],
                          ),
                          CurrentLocationLayer(
                            moveAnimationDuration: 0.2.seconds,
                            style:  const LocationMarkerStyle(
                             // marker:Image.asset(AppImages.imgMarker_persona),
                              accuracyCircleColor: Colors.blueAccent,
                              showAccuracyCircle: true,
                              markerSize: Size(18, 18),
                              markerDirection: MarkerDirection.heading,
                            ),
                          ),
                          controller.datosUpc.isNotEmpty
                              ? getMarcadores(context)
                              : markerBlanco(context),
                          warningWidgetGetX(),
                      Obx(() =>  controller.polylineCoords.isNotEmpty
                              ?   PolylineLayer(
                            polylines: [
                              controller.polylineCoords.isNotEmpty
                                  ? Polyline(
                                points: controller.polylineCoords,
                                strokeWidth: 6,
                                color: Color(0xFF093483),
                              )
                                  : Polyline(
                                  points:
                                  controller.polylineCoordsVacio),
                            ],
                          )
                              : Container()),
                        ],
                      )),

                    )
                        : Container()),
                    Column(
                      children: [
                        SizedBox(
                          height: responsive.altoP(55),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: responsive.anchoP(2),
                            ),
                            Column(
                              children: [
                                getBtnMyUbicacion(),
                                getBtnZoom(),

                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Obx(() =>
                        CargandoWidget(
                          mostrar: controller.peticionServerState.value,
                        )),
                  ],
                ),
              ))),
    );
  }

  Widget getBtnZoom() {
    Widget wgZoom = Column(
      children: <Widget>[
        CustomMap.getBtnCustomIcon(
            icon: Icons.zoom_in,
            colorIcon: Colors.blue.shade900,
            colorRelleno: controller.colorBtnRelleno,
            ontap: () {
              var centerZoom = controller.zoomMap;
              var zoom = centerZoom + 1;
              if (zoom <= controller.maxZoom) {
                controller.zoomMap = zoom;
                controller.mapController.move(
                    LatLng(AppConfig.ubicacion.value.latitude,
                        AppConfig.ubicacion.value.longitude),
                    controller.zoomMap);
                controller.btnZoomMas = true;
                controller.btnZoomMenos = true;
              }
            },
            size: controller.sizeBtnSobreMapa),
        CustomMap.getBtnCustomIcon(
            icon: Icons.zoom_out,
            colorIcon: Colors.blue.shade900,
            colorRelleno: controller.colorBtnRelleno,
            ontap: () {
              var centerZoom = controller.zoomMap;
              var zoom = centerZoom - 1;
              print(zoom);
              print(controller.minZoom);
              if (zoom >= controller.minZoom) {
                controller.zoomMap = zoom;
                controller.mapController.move(
                    LatLng(AppConfig.ubicacion.value.latitude,
                        AppConfig.ubicacion.value.longitude),
                    controller.zoomMap);
                controller.btnZoomMenos = true;
                controller.btnZoomMas = true;
              }
            },
            size: controller.sizeBtnSobreMapa)
      ],
    );

    return wgZoom;
  }

  Widget getBtnMyUbicacion() {
    return Column(
      children: <Widget>[
        CustomMap.getBtnCustomIcon(
            icon: Icons.my_location,
            colorIcon: Colors.blue.shade900,
            colorRelleno: controller.colorBtnRelleno,
            ontap: () {
              controller.polylineCoords.clear();
              controller. consultarUpc();
            },
            size: controller.sizeBtnSobreMapa),
        CustomMap.getBtnCustomIcon(
            icon: Icons.filter_center_focus,
            colorIcon: Colors.blue.shade900,
            colorRelleno: controller.colorBtnRelleno,
            ontap: () {
              controller.getBount();
            },
            size: controller.sizeBtnSobreMapa)
      ],
    );
  }

  MarkerLayer markerBlanco(BuildContext context) {
    List<Marker> markers = [];
    return MarkerLayer(markers: markers);
  }

  MarkerLayer getMarcadores(BuildContext context) {
    List<Marker> markers = [];
    double d = 0.0;
    for (int i = 0; i < controller.datosUpc.length; i++) {
      d = double.parse(controller.datosUpc[i].distance) * 1000;
      markers.add(Marker(
          width: 70.0,
          height: 70.0,
          point: LatLng(double.parse(controller.datosUpc[i].latitudUpc),
              double.parse(controller.datosUpc[i].longitudUpc)),
          child: stiloMarcador(
            nom: controller.datosUpc[i].descripcionUpc,
            valueKey: i.toString(),
            dir: controller.datosUpc[i].dirUpc,
            distancia: '${d.toStringAsFixed(2)}  mts.',
            long2:controller.datosUpc[i].longitudUpc,
            lat1:AppConfig.ubicacion.value.latitude.toString(),
            lat2:controller.datosUpc[i].latitudUpc,
            long1:AppConfig.ubicacion.value.longitude.toString(),
            telf: controller.datosUpc[i].fonoUpc,
            context: context,
            icon: AppImages.imgMarker_upc,
            mail: controller.datosUpc[i].mailUpc,


          )));
    }
    return MarkerLayer(markers: markers);
  }

  getLimpiaMarcadores() {
    controller.datosUpc.clear();
  }

  Widget stiloMarcador(
      {required String icon, required String valueKey, required String nom, required String dir, required String lat1,
        required String long1, required String lat2, required String long2, required String telf, required String distancia, required String mail,
        required BuildContext context }) {
    Key key = ValueKey(valueKey);
    return Container(
      key: key,
      child: IconButton(
        icon: Image.asset(icon),
        color: Colors.blue,
        iconSize: 20.0,
        onPressed: () {
          mostrarInfoWindowPunto(long1: long1,
              lat2: lat2,
              lat1: lat1,
              long2: long2,
              context: context,
              nombre: nom,
              dir: dir,
              mail: mail,
              imagen: '',
              telf: telf,
              dist: distancia);
        },
      ),
    );
  }

  mostrarInfoWindowPunto({
    required BuildContext context,
    required String nombre,
    required String dir,
    required String mail,
    required String imagen,
    required String telf,
    required String dist,
    required String lat1,
    required String long1,
    required String lat2,
    required String long2,
  }) {
    //controller.muestraRuta=false.obs;
    OpcionesUpcWidget.opcionUpc(lat1: lat1,
        lat2: lat2,
        long1: long1,
        long2: long2,
        ctxt: context,
        nombreUpc: nombre,
        dir: dir,
        mail: mail,
        telf: telf,
        dist: dist,
        imagen: imagen);
  }

  Marker markerPersonaVacio() {
    return Marker(
      point:
      LatLng(controller.latitudMiUbicacion, controller.longitudMiUbicacion),
      child: Container(),
      height: 0,
      width: 0,
    );
  }
  Marker markerPersona() {
    return Marker(
      point:
      LatLng(AppConfig.ubicacion.value.latitude, AppConfig.ubicacion.value.longitude,),
      child: Image.asset(AppImages.imgMarker_persona),
      height: 55,
      width: 55,
    );
  }
  getAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[900],
      title: const Text(
        textAlign: TextAlign.center,
        "Encuentra la Upc más cercana",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 30,
              onPressed: () => Get.back(),
              tooltip: 'Atrás',
            ),
          );

        },
      ),
    );
  }

  Widget bannerInferior(ResponsiveUtil responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF001F54), Color(0xFF003580)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          imgBanner(
            onTap: launchURLFace,
            ruta: AppImages.imgFacebook,
            responsive: responsive,
          ),
          imgBanner(
            onTap: launchURLTwitter,
            ruta: AppImages.imgTwitter,
            responsive: responsive,
          ),
          imgBanner(
            onTap: launchURLInsta,
            ruta: AppImages.imgInstagran,
            responsive: responsive,
          ),
          imgBanner(
            onTap: launchURLYou,
            ruta: AppImages.imgYoutube,
            responsive: responsive,
          ),
        ],
      ),
    );
  }

  static Future<void> launchURLFace() async {
    final url = Uri.parse('https://www.facebook.com/policia.ecuador');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
  static Future<void>  launchURLTwitter() async {
    final url = Uri.parse('https://twitter.com/PoliciaEcuador');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void>  launchURLInsta() async {
    final url = Uri.parse('https://www.instagram.com/policiaecuadoroficial');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void>  launchURLYou() async {
    final url = Uri.parse('https://www.youtube.com/user/policiaecuador2');
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
