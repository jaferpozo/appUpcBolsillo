part of '../pages.dart';

class EventosPage extends GetView<EventosController> {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkAreaItemsPageWidget(
      titleAppBar: 'Botón de Emergencia',
      btnAtras: false,
      peticionServer: controller.peticionServerState,
      contenido: getContenido(),
    );
  }

  Widget getContenido() {
    final responsive = ResponsiveUtil();

    return Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                getCabecera(responsive),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.anchoP(2),
                  ),
                  child: getDesingContenido(responsive),
                ),
              ],
            ),
            warningWidgetGetX(),
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

  Widget getDesingContenido(ResponsiveUtil responsive) {
    return SingleChildScrollView(
      child: Column(
        children: [

          Card(
            color: Colors.white,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ComboBusqueda(title: "Eventos",
                    selectValue: controller.selectDelito.value,
                    showClearButton: false,
                    datos: controller.listDelito,
                    displayField: (item) => item,
                    searchHint: "Seleccione un evento",
                    complete: (value) {
                      controller.selectDelito.value = "";
                      controller.mostrarBtnGuardar(true);
                      if (value != null) {
                        controller.selectDelito.value = value;
                      }
                    },
                    textSeleccioneUndato: "Seleccione un Evento",
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Observación',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.diagonalP(1.9),
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ContadorTextArea(
                    maxLength: 100,
                    controller: controller.descripcionController,
                    onChanged: (texto) {},
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () =>
                        controller.selectDelito.value.isNotEmpty
                            ? wgFoto(responsive)
                            : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  btnGuardar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget btnGuardar() {
    controller.connectionStatusController();
    return Obx(() {
      final online = controller.status.value == ConnectionStatus.online;
      final delitoSeleccionado = controller.selectDelito.value.isNotEmpty;
      final imagenCargada = controller.mGaleryCameraModel.value != null;

      if (!delitoSeleccionado || !imagenCargada) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: online?ElevatedButton.icon(
          onPressed: () async {
            await controller.guardarEvento();
          },
          icon: const Icon(Icons.save_alt_rounded, size: 24),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              "Guardar Evento",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
          ),
        ):ElevatedButton.icon(
          onPressed: () async {
            DialogosAwesome.getError(descripcion: "No tiene Internet para realizar el registro");
          },
          icon: const Icon(Icons.save_alt_rounded, size: 24),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              "Guardar Evento",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 8,
            shadowColor: Colors.black26,
          ),
        ),
      );
    });

  }
  Widget wgFoto(ResponsiveUtil responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TituloTextWidget(title: "Seleccione una Imagen"),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            controller
                .mGaleryCameraModel
                .value = await PhotoHelper.getDesingPictureGaleryOrCamera(
              initPeticion: (value) {
                controller.peticionServerState(value);
              },
              titleImg: "foto${controller.selectDelito.value}",
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.grey.shade100,
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.add_a_photo, color: Colors.blue[900]),
                const SizedBox(width: 10),
                Text(
                  controller.mGaleryCameraModel.value == null
                      ? "Registre una Imagen"
                      : "Cambiar la Imagen",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Obx(
          () =>
              controller.mGaleryCameraModel.value == null
                  ? const SizedBox.shrink()
                  : Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    controller.mGaleryCameraModel.value!.imageFile,
                    fit: BoxFit.fill,
                    height: responsive.altoP(34.0),
                    width: responsive.altoP(34.0),
                  ),
                ),
              )
        ),
      ],
    );
  }
}
