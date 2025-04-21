part of '../providers_impl.dart';

const _PREF_TOKEN = 'TOKEN';
const _PREF_USUARIO = 'USER';

const _PREF_MAIL = 'MAIL';
const _PREF_ACUERDO = 'ACUERDO';

const _PREF_ITEMS = 'ITEMS';

const _PREF_LIST_MODULOS = 'LIST_MODULO';
const _PREF_LIST_SERVICIOS = 'LIST_SERVICIOS';

const _PREF_PASS = 'PASS';

const _PREF_APP_INICIAL =
    'APP_INICIAL'; // sirve para controlar si el usuario recien instalo la aplicacion y mostrarle directamente el login
const _PREF_TIENE_HUELLA = 'TIENE_HUELLA';
const _PREF_USER_NAME = 'USER_NAME';
const _PREF_THEME = 'THEME_DARK';
const _PREF_CONTADOR_FALLIDO =
    'CONTADOR_FALLIDO'; //Cuando el usuario a cambiado la clave y al precionar la huella por segunda  vez y no ingresa tiene que reiniciarse
//para que se loguee con su nueva cuenta

class LocalStoreProviderImpl extends LocalStorageRepository {
  @override
  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<String> getDatosAcuerdo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_ACUERDO) ?? '';
  }

  @override
  Future<bool> setDatosAcuerdo(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_ACUERDO, value);
    return true;
  }

  @override
  Future<String> getDatosMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_MAIL) ?? '';
  }

  @override
  Future<String> getDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_USUARIO) ?? '';
  }

  @override
  Future<bool> setDatosMail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_MAIL, value);
    return true;
  }

  @override
  Future<bool> setDatosUsuario(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_USUARIO, value);
    return true;
  }

  @override
  Future<List<Modulo>> getListModulos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_LIST_MODULOS) ?? '';
    if(_json.length==0){
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<Modulo>.from(datos["datos"].map((x) => Modulo.fromJson(x)));
  }

  @override
  Future<bool> setDatosListaModulos({required List<Modulo> listModulos}) async {
    Map<String, dynamic> toJson() => {
      "datos": List<dynamic>.from(listModulos.map((x) => x.toJson())),
    };
    String datos = json.encode(toJson());
    log(datos);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_LIST_MODULOS, datos);
    return true;
  }

  @override
  Future<List<Servicio>> getListServicios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_LIST_SERVICIOS) ?? '';

    if(_json.length==0){
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<Servicio>.from(datos["datos"].map((x) => Servicio.fromJson(x)));
  }

  @override
  Future<bool> setDatosListaServicios({
    required List<Servicio> listServicios,
  }) async {
    Map<String, dynamic> toJson() => {
      "datos": List<dynamic>.from(listServicios.map((x) => x.toJson())),
    };

    String datos = json.encode(toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_LIST_SERVICIOS, datos);
    return true;
  }

  @override
  Future<List<ItemOffLine>> getListItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_ITEMS) ?? '';

    if(_json.length==0){
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<ItemOffLine>.from(datos["datos"].map((x) => ItemOffLine.fromJson(x)));
  }


  @override
  Future<bool> setDatosListaItems({required List<ItemOffLine> listItems}) async {
    Map<String, dynamic> toJson() => {
      "datos": List<dynamic>.from(listItems.map((x) => x.toJson())),
    };

    String datos = json.encode(toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_ITEMS, datos);
    return true;
  }
}
