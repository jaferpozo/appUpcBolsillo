part of '../controllers.dart';

class MenuPrincipalController extends GetxController {
  RxBool peticionServerState = false.obs;
  late StreamSubscription connectionSubscription;
  final status = Rx<ConnectionStatus>(ConnectionStatus.online);
  final GpsController gpsController = Get.find<GpsController>();
  final ModulosApiImpl _apiModulosRepository = Get.find<ModulosApiImpl>();
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

  String general1 = "", general2 = "", imagen = "";
  String n1 = "", n2 = "", n3 = "", n4 = "", n5 = "", n6 = "", n7 = "", n8 = "";

  //variable para que solo carge una vez los datos
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
    // TODO: el contolloler se ha creado pero la vista no se ha renderizado
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }

  _init() async {
    print(Get.deviceLocale.toString());
  }

  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  _verificaDatos() async {
    print("SPLASH: verificando datos");
    userPref.value = await _localStoreImpl.getDatosUsuario();
    acuerdo = await _localStoreImpl.getDatosAcuerdo();
  }

  verificarGps() async {
    //se verifica si el GPS del dispositivo seta activo y tiene permisos
    bool verificarGps = await gpsController.verificarGPS();
    if (verificarGps) {
      gpsController.iniciarSeguimiento();
     // iniciarSeguimiento1();
      if (AppConfig.ubicacion.value.latitude==0.0) {
        DialogosAwesome.getInformation(
            descripcion: "Las coordenas aun no estan lista vuelva a intentar");
      }else{
        gpsController.cancelarSeguimiento();
        Get.toNamed(AppRoutes.MAPAUPC);

      }
    }
  }

  connectionStatusController() {
    connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => status.value = newStatus);
    if (status.value == ConnectionStatus.online){
      verificaTConexion();
    }

  }

  verificaTConexion() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        estadoConex = 'S';
        print('connected');
        cargarDatosLista();
      }
    } on SocketException catch (_) {
      estadoConex = 'N';
    }
  }

  cargarDatosLista() async {
    try {

      listaModulo.clear();
      peticionServerState(true);
      listaModulo.value = await _apiModulosRepository.buscaListaModulos();
      print('----------------------*$listaModulo');
      if (listaModulo.isNotEmpty) {}
      peticionServerState(false);
   } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    }
  }


}
