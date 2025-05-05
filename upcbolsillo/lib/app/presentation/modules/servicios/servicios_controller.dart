part of '../controllers.dart';

class ServiciosController extends GetxController {
  RxBool peticionServerState = false.obs;

  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  late StreamSubscription connectionSubscription;
  final status = Rx<ConnectionStatus>(ConnectionStatus.online);

  final ServiciosApiImpl _apiServiciosRepository = Get.find<ServiciosApiImpl>();
  Rx<Servicio> datosServicios =
      Servicio(
        descripcion: '',
        descTiposervicio: '',
        idUpcServicio: 0,
        imgBase64: '',
        resumen: '',
        urlImagen: '',
      ).obs;

  RxList<Servicio> listaServicios = <Servicio>[].obs;
  final ItemsApiImpl _apiItemsRepository = Get.find<ItemsApiImpl>();
  Rx<Item> datosItemServicios = Item(descripcion: '', idUpcServitems: 0).obs;
  RxList<Item> listaItemsServicios = <Item>[].obs;
  RxList<ItemOffLine> listaItemsServiciosTodos = <ItemOffLine>[].obs;
  String detalle = 'RECUERDE LO SIGUIENTE';
  RxList<String> listaDetalleItemsServicios = <String>[].obs;

  var datosServicio = Get.parameters;
  String imagenModulo = "";
  String fecha = "";
  String estadoConex = "";
  int id = 0;

  @override
  void onInit() {
    cargarDatosLista();
    cargarDatosListaItemsOffline();
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

  verificaTConexion() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        estadoConex = 'S';
      } else {
        if (id==1){ listaServicios.value = await _localStoreImpl.getListServiciosPoli();}
        if (id==2){listaServicios.value = await _localStoreImpl.getListServicios();}
        listaItemsServiciosTodos.value = await _localStoreImpl.getListItems();
      }
    } on SocketException catch (_) {
      if (id==1){ listaServicios.value = await _localStoreImpl.getListServiciosPoli();}
      if (id==2){listaServicios.value = await _localStoreImpl.getListServicios();}
      listaItemsServiciosTodos.value = await _localStoreImpl.getListItems();
      estadoConex = 'N';
    }
  }

  cargarDatosLista() async {
    try {
      id = int.parse(datosServicio['id'].toString());
      imagenModulo = datosServicio['imagen'].toString();
      fecha = 'Hoy es ${UtilidadesUtil.getFechaActual}';
      listaServicios.clear();
      peticionServerState(true);

      listaServicios.value = await _apiServiciosRepository.buscaListaServicios(
        id,
      );
      if (listaServicios.isNotEmpty && listaServicios[0].idUpcServicio == 2) {
        detalle = 'COMO ACCEDER A ESTE SERVICIO';
      }

      if (listaServicios.isEmpty) {
        if (id==1){ listaServicios.value = await _localStoreImpl.getListServiciosPoli();}
        if (id==2){listaServicios.value = await _localStoreImpl.getListServicios();}
        return;
      }
      if (id == 1) {
        await _localStoreImpl.setDatosListaServiciosPoli(
          listServiciosPoli: listaServicios,
        );
      }
      if (id == 2) {
        await _localStoreImpl.setDatosListaServicios(
          listServicios: listaServicios,
        );
      }

      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);
      if (id==1){ listaServicios.value = await _localStoreImpl.getListServiciosPoli();}
      if (id==2){listaServicios.value = await _localStoreImpl.getListServicios();}


    }
  }

  cargarDatosDetalleLista(int id) async {
    try {
      listaItemsServicios.clear();
      peticionServerState(true);
      listaItemsServicios.value = await _apiItemsRepository.buscaDatosItem(id);
      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);
      DialogosAwesome.getError(descripcion: e.cause);
    }
  }

  cargarDatosListaItemsOffline() async {
    try {
      listaItemsServiciosTodos.clear();
      peticionServerState(true);

      listaItemsServiciosTodos.value =
          await _apiItemsRepository.buscaDatosItemsOffline();
      if (listaItemsServiciosTodos.isEmpty) {
        listaItemsServiciosTodos.value = await _localStoreImpl.getListItems();
        return;
      }
      await _localStoreImpl.setDatosListaItems(
        listItems: listaItemsServiciosTodos.value,
      );
      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);
      var list = await _localStoreImpl.getListItems();
      listaItemsServiciosTodos.value = list;
    }
  }

  cargarDatosDetalleListaOffLine(int id) async {
    try {
      listaItemsServicios.clear();
      listaItemsServiciosTodos.clear();
      listaItemsServiciosTodos.value = await _localStoreImpl.getListItems();
      peticionServerState(true);
      for (var i = 0; i < listaItemsServiciosTodos.length; i++) {
        if (listaItemsServiciosTodos[i].idUpcServicio == id) {
          listaItemsServicios.add(
            Item(
              descripcion: listaItemsServiciosTodos[i].descripcion,
              idUpcServitems: listaItemsServiciosTodos[i].idUpcServitems,
            ),
          );
        }
      }
      peticionServerState(false);
    } on ServerException catch (e) {
      peticionServerState(false);
    }
  }
}
