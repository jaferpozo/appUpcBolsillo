part of '../controllers.dart';

class EventosController extends GetxController {
  RxBool peticionServerState = false.obs;
  late StreamSubscription connectionSubscription;
  final status = Rx<ConnectionStatus>(ConnectionStatus.online);

  final ServiciosRepository _apiServiciosRepository = Get.find();

  final SaveFileImgUseCase _saveFileImgUseCase = Get.find();
  final TextEditingController descripcionController = TextEditingController();
  Rx<GaleryCameraModel?> mGaleryCameraModel = Rx<GaleryCameraModel?>(null);
  Rx<Servicio> datosEventos =
      Servicio(
        descripcion: '',
        descTiposervicio: '',
        idUpcServicio: 0,
        imgBase64: '',
        resumen: '',
        urlImagen: '',
      ).obs;
  RxList<Servicio> listaEventos = <Servicio>[].obs;

  Rx<Item> datosItemEventos = Item(descripcion: '', idUpcServitems: 0).obs;
  RxList<Item> listaItemsEventos = <Item>[].obs;
  String detalle = 'RECUERDE LO SIGUIENTE';
  RxList<String> listaDetalleItemsEventos = <String>[].obs;

  RxList<String> listDelito =
      <String>[
        "ROBO",
        "HURTO",
        "ATROPELLAMIENTO",
        "ACCIDENTE DE TRÁNSITO",
        "OTROS",
      ].obs;
  RxString selectDelito = "".obs;

  RxBool mostrarBtnGuardar = false.obs;

  var datosServicio = Get.parameters;
  String imagenModulo = "";
  String fecha = "";
  String estadoConex = "";
  int id = 0;
  bool _notificacionesIniciadas = false;
  @override
  void onInit() {
    fecha = 'Hoy es ${UtilidadesUtil.getFechaActual}';
    imagenModulo = datosServicio['imagen'].toString();
    super.onInit();
  }

  @override
  void onReady() {
    _init();
    if (!_notificacionesIniciadas) {
      _initNotificaciones();
      _notificacionesIniciadas = true;
    }
  }

  _init() async {
  }

  connectionStatusController() {
    connectionSubscription = internetChecker.internetStatus().listen(
          (newStatus) => status.value = newStatus,
    );
  }

  guardarEvento() async {
    await FirebaseMessaging.instance.requestPermission();

    try {
      String path = dotenv.env['PATH_IMG_ELECCIONES'] ?? '';
      String nameFile = "eventos";
      FileRequest request = FileRequest(
        file: mGaleryCameraModel.value!.imageFile,
        path: path,
        nameFile: nameFile,
      );

      peticionServerState(true);
      bool insertImg = await _saveFileImgUseCase(request: request);
      peticionServerState(false);

      if (!insertImg) {
        DialogosAwesome.getWarning(
          title: "Guardar Imagen",
          descripcion: "No se pudo guardar la Imagen",
          btnOkOnPress: () {
            Get.back();
          },
        );
        return;
      }
      peticionServerState(true);
      String nameCompletoImg =
          "${nameFile}_${mGaleryCameraModel.value!.nombreImg}";

      bool resultInsert = await _apiServiciosRepository.registrarEvento(
        tipoEvento: selectDelito.value,
        descripcion: descripcionController.text,
        imagen: nameCompletoImg,
      );

     if (resultInsert) {
       DialogosAwesome.getSucess(
         descripcion: "Notificación enviada",
         title: "REGISTRO CORRECTO",
         btnOkOnPress: () {
           peticionServerState(false);
           Get.back();
           Get.back();
         },
       );

      } else {
        DialogosAwesome.getWarning(descripcion: "INTENTE OTRA VEZ");
        peticionServerState(false);
      }
      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    } catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.toString());
    }
  }

  void _initNotificaciones() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.subscribeToTopic('upceventos1');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final titulo = message.notification?.title ?? "Sin título";
      final cuerpo = message.notification?.body ?? "Sin cuerpo";

      if (titulo.toString()=="WEB"){
        mostrarSnackbarConEstilo(
          titulo: titulo,
          mensaje: cuerpo,
          icono: Icons.notifications_active_sharp,
          colorFondo: Colors.red,
          colorTexto: Colors.white,
        );
      }else if(titulo.toString()=="SEGUIMIENTO"){
        mostrarSnackbarConEstilo(
          titulo: titulo,
          mensaje: cuerpo,
          icono: Icons.notification_add_outlined,
          colorFondo: Colors.amber,
          colorTexto: Colors.black,
        );
      }
      else{

      }
    });
  }


  void mostrarSnackbarConEstilo({
    required String titulo,
    required String mensaje,
    IconData icono = Icons.notifications,
    Color colorFondo = Colors.white,
    Color colorTexto = Colors.black,
    Duration duracion = const Duration(seconds: 5),
  }) {
    Get.snackbar(
      titulo,
      mensaje,
      icon: Icon(icono, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: colorFondo.withOpacity(0.95),
      colorText: colorTexto,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 500),
      duration: duracion,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      overlayBlur: 1.5,
      boxShadows: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      shouldIconPulse: true,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );

  }

}

