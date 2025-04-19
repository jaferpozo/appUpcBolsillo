part of '../pages.dart';

class EventosPage extends GetView<EventosController> {
  const EventosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WorkAreaItemsPageWidget(
      btnAtras: true,

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
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.imgFondo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    getCabecera(responsive),
                    SizedBox(
                      width: responsive.anchoP(88),
                      height: responsive.altoP(76),
                      child: getDesingContenido(),
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

  warningWidgetGetX() {
    controller.connectionStatusController();
    return Obx(() {
      return Visibility(
        visible: controller.status.value != ConnectionStatus.online,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 70,
              color: Colors.red,
              child: const Row(
                children: [
                  Icon(Icons.wifi_off),
                  SizedBox(width: 10),
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
            const SizedBox(height: 10),
          ],
        ),
      );
    });
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
                child: SizedBox(
                  width: responsive.altoP(20),
                  child: Image.asset(AppImages.imgCabecera2),
                ),
              ),
              Container(
                color: Colors.blue[900],
                child: Column(
                  children: <Widget>[
                    const Divider(color: Colors.transparent, height: 5.0),
                    const Divider(color: Colors.transparent, height: 3.0),
                    Container(
                      color: Colors.white,
                      child: Text(
                        '   ${controller.fecha}    ',
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



  getDesingContenido(){
    return Container(


      child: Column(children: [
      SizedBox(height: 5,),
      ComboBusqueda(
        selectValue: controller.selectDelito.value,

        showClearButton: false,
        datos: controller.listDelito,
        displayField:
            (item) =>
        item, // Aquí decides mostrar "nombres"
        searchHint: "Delito",
        complete: (value) {
          controller.selectDelito.value = "";
          controller.mostrarBtnGuardar(false);
          if (value != null) {
            controller.selectDelito.value = value;
            return;
          }
        },
        textSeleccioneUndato: "Seleccione el Delito",
      ),
        SizedBox(height: 15,),
      Text("AQUI EL DISEÑO DE LA DESCRIPCION "),
      SizedBox(height: 15,),
     Obx(()=>controller.selectDelito.value.length>0? wgFoto():Container()),

        SizedBox(height: 15,),
        btnGuardar(),

    ],),);
  }

Widget btnGuardar(){
    return Obx(()=>
    controller.selectDelito.value.length>0?controller.mGaleryCameraModel.value!=null?

    BtnIconWidget(
        size: 18,
        title: "GUARDAR",
        onTap: (){
      controller.guardarEvento();
        }, iconData: Icons.save, color: Colors.blue):Container():Container());
}

  Widget wgFoto() {

    final responsive = ResponsiveUtil();
    Widget wgSolicitarFoto = Column(
      children: [
        Obx(()=>controller.mGaleryCameraModel.value == null
            ? TituloTextWidget(title: "Registre una Imagen")
            : TituloTextWidget(title: "Cambiar la Imagen"),),
        SizedBox(height: responsive.altoP(1)),
        Material(
          child: InkWell(
            onTap: () async {
              controller
                  .mGaleryCameraModel
                  .value = await PhotoHelper.getDesingPictureGaleryOrCamera(

                initPeticion: (value){
                  controller.peticionServerState(value);
                },
                titleImg:
                "foto${controller.selectDelito.value}",
              );
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  AppImages.imgInstagran,
                  width: responsive.altoP(6.0),
                ),
              ),
            ),
          ),
        ),
       Obx(()=> controller.mGaleryCameraModel.value == null
           ? Container()
           : ClipRRect(
         borderRadius: BorderRadius.circular(25.0),
         child: Image.file(
           controller.mGaleryCameraModel.value!.imageFile,
           fit: BoxFit.fill,
           height: responsive.altoP(30.0),
           width: responsive.altoP(34.0),
         ),
       )),
        SizedBox(height: responsive.altoP(1)),
      ],
    );

    Widget wg = wgSolicitarFoto;



    return ContenedorDesingWidget(margin: EdgeInsets.only(top: 10), child: wg);
  }

}
