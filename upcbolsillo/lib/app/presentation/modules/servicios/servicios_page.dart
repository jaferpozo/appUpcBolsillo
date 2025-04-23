part of '../pages.dart';

class ServiciosPage extends GetView<ServiciosController> {
  const ServiciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkAreaItemsPageWidget(
      titleAppBar: 'Medidas de Autoprotección',
      btnAtras: false,
      peticionServer: controller.peticionServerState,
      contenido: getContenido(),
    );
  }

  getContenido() {
    final responsive = ResponsiveUtil();
    return Column(
      children: [
        Stack(
          children: [

            Stack(
              children: [
                Column(
                  children: [
                    getCabecera(responsive),
                    SizedBox(height: responsive.altoP(2),),
                    SizedBox(
                      width: responsive.anchoP(88),
                      height: responsive.altoP(68),
                      child: Obx(() => getListaServicios()),
                    ),
                  ],
                ),
                warningWidgetGetX(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget warningWidgetGetX() {
    controller.connectionStatusController();
    return Obx(() {
      final online = controller.status.value == ConnectionStatus.online;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: online ? 0 : 40,
        child: online
            ? const SizedBox.shrink()
            : Container(
          width: double.infinity,
          color: Colors.redAccent,
          alignment: Alignment.center,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Sin conexión a Internet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  getListaServicios() {
    final resposnsive = ResponsiveUtil();
    Widget listaU = ListView.builder(
      padding: const EdgeInsets.only(top: 2),
      shrinkWrap: true,
      itemCount:
          controller.listaServicios != null
              ? controller.listaServicios.length
              : 0,
      itemBuilder: (context, ind) {
        return Obx(
          () => InkWell(
            onTap: () => {getDatosServicio(ind)},
            child: Column(
              children: [
                SizedBox(
                  width: resposnsive.anchoP(95),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: resposnsive.anchoP(2.0)),
                          imgPerfilRedonda(
                            size: 20,
                            img:
                                controller.listaServicios[ind].imgBase64 == ''
                                    ? null
                                    : controller.listaServicios[ind].imgBase64,
                          ),
                          SizedBox(width: resposnsive.anchoP(4)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: resposnsive.anchoP(50),
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  controller.listaServicios[ind].descripcion
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: resposnsive.diagonalP(1.5),
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

  Widget getCabecera(ResponsiveUtil responsive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ Colors.grey,Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar circular
            CircleAvatar(
              radius: responsive.altoP(4.5),
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: ImagenBase64Widget(
                  base64String: controller.imagenModulo,
                  height: responsive.altoP(9),
                  isCircular: false,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Texto de fecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha del evento:',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      controller.fecha,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDatosServicio(int ind) async {
    String resumen = controller.listaServicios[ind].resumen.toString();
    String img = controller.listaServicios[ind].imgBase64;
    int id = controller.listaServicios[ind].idUpcServicio;
    String servicio = controller.listaServicios[ind].descripcion;
    controller.status.value== ConnectionStatus.online? await controller.cargarDatosDetalleLista(id): controller.cargarDatosDetalleListaOffLine(id);
    DialogosAwesome.getAlertDetalleServicios(
      body: bodyDetlleListaServicios(resumen, servicio),
      imagen: img,
    );
  }

  bodyDetlleListaServicios(String resumen, String servicio) {
    final responsive = new ResponsiveUtil();
    Widget tarea = Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF06245B),
                  border: Border.all(color: Colors.grey), //Border.all
                  borderRadius: BorderRadius.circular(15),
                ),
                height: responsive.altoP(4),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.justify,
                    servicio,
                    style: TextStyle(
                      fontSize: responsive.diagonalP(1.4),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.altoP(2)),
              Container(
                width: responsive.anchoP(70.0),
                child: Text(
                  textAlign: TextAlign.justify,
                  resumen,
                  style: TextStyle(
                    fontSize: responsive.diagonalP(1.4),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: responsive.altoP(2)),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF06245B),
                  border: Border.all(color: Colors.grey), //Border.all
                  borderRadius: BorderRadius.circular(15),
                ),
                height: responsive.altoP(4),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.justify,
                    controller.detalle,
                    style: TextStyle(
                      fontSize: responsive.diagonalP(1.4),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              getListaItemsServicios(),
            ],
          ),
        ],
      ),
    );
    return tarea;
  }

  getListaItemsServicios() {
    final resposnsive = ResponsiveUtil();
    Widget listaU = Obx(
      () => Container(
        height: resposnsive.altoP(30),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 2),
          itemCount: controller.listaItemsServicios.length,
          itemBuilder: (context, ind) {
            return Padding(
              padding: EdgeInsets.only(right: 5, left: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: resposnsive.anchoP(2)),
                      Image.asset(
                        height: resposnsive.altoP(4),
                        width: resposnsive.anchoP(4),
                        AppImages.vineta,
                      ),
                      SizedBox(width: resposnsive.anchoP(2)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: resposnsive.anchoP(65.0),
                            child: Text(
                              textAlign: TextAlign.justify,
                              controller.listaItemsServicios[ind].descripcion,
                              style: TextStyle(
                                fontSize: resposnsive.diagonalP(1.3),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
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
            );
          },
        ),
      ),
    );
    return listaU;
  }
}
