part of '../pages.dart';

class MenuPrincipalPage extends GetView<MenuPrincipalController> {
  const MenuPrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkAreaMenuPageWidget(
      btnAtras: false,
      pantallaIrAtras: () => Get.back(),
      peticionServer: controller.peticionServerState,
      contenido: Obx(
        () =>
            controller.status.value == ConnectionStatus.online
                ? getContenido()
                : getContenido(),
      ),
    );
  }
  warningWidgetGetX() {
    controller.connectionStatusController();
    return Obx(() {
      return Visibility(
          visible: controller.status.value != ConnectionStatus.online,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 40,
                color: Colors.red,
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off),
                    SizedBox(width: 5),
                    Text(
                      'No tiene Conexión a Internet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
  getContenido() {
    final responsive = ResponsiveUtil();
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.imgFondo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            getCabecera(responsive),
            SizedBox(
              width: responsive.anchoP(88),
              height: responsive.altoP(65),
              child: Obx(() => getListaDatosModulos()),
            ),
          ],
        ),
        warningWidgetGetX(),
      ],
    );
  }


  getListaDatosModulos() {
    final responsive = ResponsiveUtil();
    Widget listaU = ListView.builder(
      shrinkWrap: true,
      itemCount:
          controller.listaModulo != null ? controller.listaModulo.length : 0,
      itemBuilder: (context, ind) {
        return Obx(
          () => InkWell(
            onTap: () => {
              muestraPantalla(ind, context)
            },
            child: Column(
              children: [
                SizedBox(
                  width: responsive.anchoP(90),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: responsive.anchoP(2.0)),
                          imgPerfilRedonda(
                            size: 22,
                            img:
                                controller.listaModulo[ind].imgBase64 == ''
                                    ? null
                                    : controller.listaModulo[ind].imgBase64,
                          ),
                          SizedBox(width: responsive.anchoP(6)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: responsive.anchoP(50),
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  controller.listaModulo[ind].tituloModulo
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: responsive.diagonalP(1.7),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: AppConfig.colorBarras),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return listaU;
  }

  getCabecera(ResponsiveUtil responsive) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  child: Image.asset(AppImages.imgCabecera_menu_principal),
                  width: responsive.altoP(40),
                ),
              ),
              Container(
                color: Colors.blue[900],
                child: Column(
                  children: <Widget>[
                    const Divider(color: Colors.transparent, height: 5.0),
                    Obx(
                      () =>
                          controller.userPref != ''
                              ? Text(
                                'BIENVENID@ ${controller.userPref.value}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.diagonalP(1.3),
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                'BIENVENID@ ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: responsive.diagonalP(1.5),
                                  color: Colors.white,
                                ),
                              ),
                    ),
                    const Divider(color: Colors.transparent, height: 3.0),
                    Container(
                      color: Colors.white,
                      child: Text(
                        'Hoy es ${UtilidadesUtil.getFechaActual}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: AppConfig.colorBarras,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.transparent, height: 3.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  muestraPantalla(index, BuildContext ctx) async {
    if (index == 0) {
     if( controller.status==ConnectionStatus.online){
       controller.verificarGps();
     }else{
       DialogosAwesome.getError(descripcion: "No tiene Conexión a Internet");
     }
    }
    if (index == 1) {
      if( controller.status==ConnectionStatus.online){
        Map<String, String> data = {
          "id": "1",
          "imagen":controller.listaModulo[1].imgBase64
        };
        Get.toNamed(AppRoutes.REGISTRAR_EVENTO, parameters: data );
      }else{
        DialogosAwesome.getError(descripcion: "No tiene Conexión a Internet para registrar un evento");
      }
    }
    if (index == 2) {
      Map<String, String> data = {
        "id": "2",
        "imagen":controller.listaModulo[2].imgBase64
      };
     Get.toNamed(AppRoutes.SERVICIOS, parameters: data);
    }

  }

}
