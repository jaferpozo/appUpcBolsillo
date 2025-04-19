part of '../bindings.dart';

class EventosBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => EventosController(), fenix: true);

  }

}