part of '../controllers.dart';

class MapaUpcController extends GetxController {
  RxBool peticionServerState = false.obs;
  final internetChecker = CheckInternetConnection();
  final GpsController gpsController = Get.find<GpsController>();
  final MapaUpcApiImpl _apiMapaUpcRepository = Get.find<MapaUpcApiImpl>();
  late PolylinePoints polylinePoints;
  RxList<LatLng> polylineCoords = <LatLng>[].obs;
  RxList<LatLng> polylineCoordsVacio = <LatLng>[LatLng(0, 0)].obs;
  RxBool muestraRuta=false.obs;
  var pasosRuta = <InstructionStep>[].obs;
  var instruccionesRuta = <String>[].obs;
  Set<int> pasosDichos = {};
  RxInt pasoActual = 0.obs;
  Timer? simulacion;
  Rx<Upc> listaUpc = Upc(
          descripcionUpc: '',
          dirUpc: '',
          distance: '',
          fonoUpc: '',
          idGenUpc: 0,
          fotoUpc: '',
          latitudUpc: '',
          longitudUpc: '',
          mailUpc: '')
      .obs;
  RxList<Upc> datosUpc = <Upc>[].obs;

  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  var address = 'Getting Address..'.obs;
  late StreamSubscription<Position> streamSubscription;
  late StreamSubscription connectionSubscription;
  final status = Rx<ConnectionStatus>(ConnectionStatus.online);
  Rx<LatLng> cen = LatLng(0.0, 0.0).obs;

  double latitudMiUbicacion = 0.0, longitudMiUbicacion = 0.0;
  double zoomMap = 15;
  int totalAvazar = 0;
  bool cargarDatos = true;
  double minZoom = 5;
  double maxZoom = 18;
  double sizeBtnSobreMapa = 40;
  var wifiIP = '';
  bool mini = true;
  double padding = 2.0;
  bool btnZoomMas = true;
  bool btnZoomMenos = true;
  Color colorBtnRelleno = Colors.white;

  final Rx<LatLng> centroMapa = new LatLng(0.0, 0.0).obs;
  MapController mapController = MapController();

  @override
  void onInit() {
   _init();
    super.onInit();
  }

  @override
  void onReady() {
  }

  _init() async {
    consultarUpc();

  }
consultarUpc()async{

    if (AppConfig.ubicacionLista.isTrue){
      getDatosUpc(la:AppConfig.ubicacion.value.latitude, lo:AppConfig.ubicacion.value.longitude );
      zoomMap = 15;
      mapController.move(
          LatLng(AppConfig.ubicacion.value.latitude, AppConfig.ubicacion.value.longitude), zoomMap);
    }else{
      gpsController.iniciarSeguimiento();
    }

}
  getDatosUpc({required double la, required double lo}) async {
    try {
      datosUpc.clear();
      peticionServerState(true);
      datosUpc.value =
          await _apiMapaUpcRepository.buscaDatosUpc(la: la, lo: lo);
      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

    LatLngBounds getBount() {
      LatLngBounds bounds = LatLngBounds(
          LatLng(AppConfig.ubicacion.value.latitude, AppConfig.ubicacion.value.longitude),
          LatLng(AppConfig.ubicacion.value.latitude, AppConfig.ubicacion.value.longitude));
      for(var i=0; i<datosUpc.length; i++) {
        var location = LatLng(double.parse(datosUpc[i].latitudUpc),
            double.parse(datosUpc[i].longitudUpc));
        bounds.extend(location);
      }
      bounds.extend(new LatLng(latitudMiUbicacion, longitudMiUbicacion));
      return bounds;
  }

  connectionStatusController() {
    connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => status.value = newStatus);
  }
  Future<List<LatLng>>  createPolylines ({
    required double inicioLat,
    required double inicioLong,
    required double finLat,
    required double finLong,
  }) async {
    peticionServerState(true);
    final String osrmUrl =
        "https://routing.openstreetmap.de/routed-car/route/v1/driving/$inicioLong,$inicioLat;$finLong,$finLat?overview=full&steps=true&geometries=geojson";
    try {
      final response = await http.get(Uri.parse(osrmUrl));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final List coordinates = decodedData['routes'][0]['geometry']['coordinates'];
        polylineCoords.assignAll(
          coordinates.map((point) => LatLng(point[1], point[0])).toList(),);
        final List steps = decodedData['routes'][0]['legs'][0]['steps'];
        pasosRuta.value = steps.map((step) => InstructionStep.fromJson(step)).toList();
        instruccionesRuta.value = pasosRuta.map((p) => p.instruction).toList();
        instruccionesRuta.forEach(print);
        peticionServerState(false);
      } else {
        peticionServerState(false);
      }
    } catch (e) {
      peticionServerState(false);
    }
    return polylineCoords;
  }
}
