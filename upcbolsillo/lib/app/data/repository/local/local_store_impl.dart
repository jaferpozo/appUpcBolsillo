part of '../data_repositories.dart';

class LocalStoreImpl extends LocalStorageRepository {
  final LocalStoreProviderImpl _localStoreProviderImpl = Get.find();

  @override
  Future<String> getDatosAcuerdo() {
    return _localStoreProviderImpl.getDatosAcuerdo();
  }

  @override
  Future<bool> setDatosAcuerdo(String value) {
    return _localStoreProviderImpl.setDatosAcuerdo(value);
  }

  @override
  Future<String> getDatosMail() {
    return _localStoreProviderImpl.getDatosMail();
  }

  @override
  Future<String> getDatosUsuario() {
    return _localStoreProviderImpl.getDatosUsuario();
  }

  @override
  Future<bool> setDatosMail(String value) {
    return _localStoreProviderImpl.setDatosMail(value);
  }

  @override
  Future<bool> setDatosUsuario(String value) {
    return _localStoreProviderImpl.setDatosUsuario(value);
  }

  @override
  Future<List<Modulo>> getListModulos() async {
    return _localStoreProviderImpl.getListModulos();
  }

  @override
  Future<bool> setDatosListaModulos({required List<Modulo> listModulos}) async {
    return _localStoreProviderImpl.setDatosListaModulos(
      listModulos: listModulos,
    );
  }

  @override
  Future<List<Servicio>> getListServicios() async {
    return _localStoreProviderImpl.getListServicios();
  }

  @override
  Future<bool> setDatosListaServicios({
    required List<Servicio> listServicios,
  }) async {
    return _localStoreProviderImpl.setDatosListaServicios(
      listServicios: listServicios,
    );
  }

  @override
  Future<List<ItemOffLine>> getListItems() {
    return _localStoreProviderImpl.getListItems();
  }

  @override
  Future<bool> setDatosListaItems({required List<ItemOffLine> listItems}) async {
    return _localStoreProviderImpl.setDatosListaItems(
      listItems: listItems,
    );
  }
}
