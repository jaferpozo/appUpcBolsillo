part of '../controllers.dart';

class MenuPrincipalController extends GetxController {
  RxBool peticionServerState = false.obs;
  late StreamSubscription connectionSubscription;
  final status = Rx<ConnectionStatus>(ConnectionStatus.online);
  final GpsController gpsController = Get.find<GpsController>();
  final ModulosRepository _apiModulosRepository = Get.find<ModulosRepository>();

  Rx<Uint8List?> fotoPerfilBytes = Rx<Uint8List?>(null);
  Rx<Modulo> datosModulos = Modulo(
          descripcionModulo: '',
          imgBase64: '',
          idGenEstado: 0,
          idUpcModulosMovil: 0,
          imagenModulo: '',
          ordenModulo: 0,
          tituloModulo: '')
      .obs;
  RxList<Modulo> listaModulo = <Modulo>[].obs;
  String nombre = '';
  String cedula = '';
  String direc = "";
  String fecha = "";
  String estadoConex = "";
  String acuerdo = "";

  RxString userPref = ''.obs;

  @override
  void onInit() {
   verificaTConexion();
    _verificaDatos();
   _cargarFotoPerfil();
    super.onInit();
  }

  @override
  void onReady() {
    _init();
  }

  _init() async {
    print(Get.deviceLocale.toString());
  }

  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  Rx<GaleryCameraModel?> mGaleryCameraModel = Rx<GaleryCameraModel?>(null);

  _verificaDatos() async {
    userPref.value = await _localStoreImpl.getDatosUsuario();
    acuerdo = await _localStoreImpl.getDatosAcuerdo();
  }

  verificarGps() async {
    bool verificarGps = await gpsController.verificarGPS();
    if (verificarGps) {
      gpsController.iniciarSeguimiento();
      if (AppConfig.ubicacion.value.latitude==0.0) {
        DialogosAwesome.getInformation(
            descripcion: "Las coordenas aun no estan lista vuelva a intentar");
      }else{
        gpsController.cancelarSeguimiento();
        Map<String, String> data = {
          "id": "0",
          "imagen":listaModulo[0].imgBase64
        };
        Get.toNamed(AppRoutes.MAPAUPC,parameters: data);

      }
    }
  }
  Future<void> _cargarFotoPerfil() async {
    final bytes = await _localStoreImpl.getFoto();
    if (bytes != null) {
      fotoPerfilBytes.value = bytes;
    }
  }
  connectionStatusController() async {
    connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => status.value = newStatus);
    if (status.value == ConnectionStatus.online){
      verificaTConexion();
    }
    else{
      var list =await _localStoreImpl.getListModulos();
      listaModulo.value=list;
    }

  }
  verificaTConexion() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        cargarDatosLista();
      }
      else{

      }
    } on SocketException catch (_) {

      var list =await _localStoreImpl.getListModulos();
      listaModulo.value=list;
    }
  }

  cargarDatosLista() async {
    try {
      listaModulo.clear();
      peticionServerState(true);
      listaModulo.value = await _apiModulosRepository.buscaListaModulos();

      if(listaModulo.length==0){
        var list =await _localStoreImpl.getListModulos();
        listaModulo.value=list;
        return;
      }
      _localStoreImpl.setDatosListaModulos(listModulos: listaModulo.value);
      peticionServerState(false);
   } on ServerException catch (e) {
      peticionServerState(false);
      var list =await _localStoreImpl.getListModulos();
      listaModulo.value=list;
    }
  }


}
