part of '../controllers.dart';

class SplashController extends GetxController {


  @override
  void onInit() {

    _cargarPantallaLogin_InicioRapido();
    // TODO: el contolloler se ha creado pero la vista no se ha renderizado
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: Donde la vista ya se presento
    _init();
  }


  final LocalStoreImpl _localStoreImpl = Get.find<LocalStoreImpl>();

  _init() async {
    await FirebaseMessaging.instance.requestPermission();
    await Firebase.initializeApp();
    print(Get.deviceLocale.toString());

  }

  _cargarPantallaLogin_InicioRapido() async {

    await Future.delayed(const Duration(seconds: 2)).then((_) {

    });

      Get.offAllNamed(AppRoutes.MENU);



  }
  _verifiToken() async {
    print("SPLASH: verificando token");

    final token = await _localStoreImpl.getDatosAcuerdo();

    //verificamos si el token aun esta valido
    if (token != null) {
      print("SPLASH: tenemos token valido");
      //Tenemos token aun valido que no expira
      //vamos al login

      //se realiza el login
      String user = await _localStoreImpl.getDatosAcuerdo();
      String pass = await _localStoreImpl.getDatosAcuerdo();

      //  bool resul = await _localStoreImpl.login(user: user, pass: pass);

      bool resul=false;

    }

}
generaToken ()async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("Mi token: $token");
}


}
