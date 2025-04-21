part of '../controllers.dart';

class EventosController extends GetxController {
  RxBool peticionServerState = false.obs;

  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  late StreamSubscription connectionSubscription;
  final status = Rx<ConnectionStatus>(ConnectionStatus.online);

  final ServiciosApiImpl _apiServiciosRepository = Get.find<ServiciosApiImpl>();
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
  final ItemsApiImpl _apiItemsRepository = Get.find<ItemsApiImpl>();
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

  @override
  void onInit() {
    fecha = 'Hoy es ${UtilidadesUtil.getFechaActual}';
    imagenModulo = datosServicio['imagen'].toString();
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
      // ► Envía la notificación
      final ok = await sendEventNotification(
        title: 'Nuevo Evento Registrado',
        body: 'Tipo de delito: ${selectDelito.value}',
      );
      if (!ok) {
        debugPrint('La push no se envió correctamente.');
      } else {
        DialogosAwesome.getWarning(descripcion: "INTENTE OTRA VEZ");
      }
      peticionServerState(false);

      if (resultInsert) {
        DialogosAwesome.getSucess(descripcion: "REGISTRADO");
      } else {
        DialogosAwesome.getWarning(descripcion: "INTENTE OTRA VEZ");
      }
    } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    } catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.toString());
    }
  }

  /// Suscribe al dispositivo al topic 'eventos'
  Future<void> subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('eventos');
  }

  /// Envía una notificación al topic 'eventos'
  Future<bool> sendEventNotification({
    required String title,
    required String body,
  }) async {
    await subscribeToTopic();
    final String _serverKey = dotenv.env['FCM_SERVER_KEY']!;
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };
    final payload = {
      'to': '/topics/eventos',
      'priority': 'high',
      'notification': {'title': title, 'body': body, 'sound': 'default'},
    };

    final res = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (res.statusCode == 200) {
      debugPrint('✅ Push enviada: ${res.body}');
      return true;
    } else {
      debugPrint('❌ Error (${res.statusCode}): ${res.body}');
      return false;
    }
  }
}
