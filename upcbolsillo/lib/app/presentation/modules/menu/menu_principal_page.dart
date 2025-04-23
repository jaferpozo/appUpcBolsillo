part of '../pages.dart';

class MenuPrincipalPage extends GetView<MenuPrincipalController> {
  const MenuPrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkAreaMenuPageWidget(
      btnAtras: false,
      pantallaIrAtras: () => Get.back(),
      peticionServer: controller.peticionServerState,
      contenido:
          controller.status.value == ConnectionStatus.online
              ? getContenido()
              : getContenido(),
    );
  }

  Widget warningWidgetGetX() {
    controller.connectionStatusController();
    return Obx(() {
      final online = controller.status.value == ConnectionStatus.online;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: online ? 0 : 40,
        child:
            online
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

  Widget getContenido() {
    final responsive = ResponsiveUtil();
    return Stack(
      children: [
        // fondo...
        Column(
          children: [
            SizedBox(height: responsive.altoP(1)),
            getCabecera(responsive),
            // la grilla ya está dentro de su propio Obx
            SizedBox(
              width: responsive.anchoP(88),
              height: responsive.altoP(65),
              child: getListaDatosModulos(), // sin Obx aquí tampoco
            ),
          ],
        ),
        warningWidgetGetX(), // warningWidgetGetX() utiliza su propio Obx
      ],
    );
  }

  Widget getListaDatosModulos() {
    final responsive = ResponsiveUtil();
    return Obx(() {
      final mods = controller.listaModulo;
      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.anchoP(4),
          vertical: responsive.altoP(8),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: responsive.anchoP(4),
          mainAxisSpacing: responsive.altoP(3),
          childAspectRatio: 0.9,
        ),
        itemCount: mods.length,
        itemBuilder: (context, i) {
          final m = mods[i];
          return ModuleCard(
            title: m.tituloModulo,
            base64Img: m.imgBase64.isEmpty ? null : m.imgBase64,
            onTap: () => muestraPantalla(i, context),
          );
        },
      );
    });
  }

  Widget getCabecera(ResponsiveUtil responsive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.white],
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
            Obx(() {
              final bytes = controller.fotoPerfilBytes.value;
              return CircleAvatar(
                radius: responsive.altoP(4.5),
                backgroundColor: Colors.grey[200],
                backgroundImage: bytes != null ? MemoryImage(bytes) : null,
                child: bytes == null
                    ? Icon(
                  Icons.person,
                  size: responsive.altoP(4.5),
                  color: Colors.grey,
                )
                    : null,
              );
            }),

            const SizedBox(width: 16),
            // Texto de fecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.userPref.value.isNotEmpty
                          ? 'BIENVENID@ ${controller.userPref.value}'
                          : 'BIENVENID@',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.diagonalP(1.6),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'Hoy es ${UtilidadesUtil.getFechaActual}',
                      style: TextStyle(
                        fontSize: responsive.diagonalP(1.3),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF06245B),
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

  muestraPantalla(index, BuildContext ctx) async {
    if (index == 0) {
      if (controller.status == ConnectionStatus.online) {
        controller.verificarGps();
      } else {
        DialogosAwesome.getError(descripcion: "No tiene Conexión a Internet");
      }
    }
    if (index == 1) {
      if (controller.status == ConnectionStatus.online) {
        Map<String, String> data = {
          "id": "1",
          "imagen": controller.listaModulo[1].imgBase64,
        };
        Get.toNamed(AppRoutes.REGISTRAR_EVENTO, parameters: data);
      } else {
        DialogosAwesome.getError(
          descripcion: "No tiene Conexión a Internet para registrar un evento",
        );
      }
    }
    if (index == 2) {
      Map<String, String> data = {
        "id": "1",
        "imagen": controller.listaModulo[2].imgBase64,
      };
      Get.toNamed(AppRoutes.SERVICIOS, parameters: data);
    }
    if (index == 3) {
      Map<String, String> data = {
        "id": "2",
        "imagen": controller.listaModulo[3].imgBase64,
      };
      Get.toNamed(AppRoutes.SERVICIOS, parameters: data);
    }
  }
}
