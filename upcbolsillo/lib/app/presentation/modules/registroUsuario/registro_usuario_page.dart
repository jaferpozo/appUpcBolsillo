part of '../pages.dart';

class RegistroUsuarioPage extends GetView<RegistroUsuarioController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistroUsuarioController>(
      builder: (_) => getContenido(context),
    );
  }

  getContenido(context) {
    final responsive = ResponsiveUtil();
    return Scaffold(
      appBar: getAppBar('Registro de Usuario'),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: responsive.anchoP(100),
              height: responsive.altoP(100),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.imgarea),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(child: Image.asset(AppImages.imgCabecera)),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Divider(color: AppConfig.colorBarras),
                            const Divider(
                              height: 5.0,
                              color: Colors.transparent,
                            ),
                            Divider(height: 5.0, color: Colors.transparent),
                            Text(
                              'INSTRUCCIONES',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Divider(height: 5.0, color: Colors.transparent),
                            Text(
                              'Favor registre los siguientes datos para continuar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            Divider(height: 5.0, color: Colors.transparent),
                            getContenidonacional(responsive),

                            //getCombo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //CargandoWidget(mostrar: ),
          ],
        ),
      ),
    );
  }

  Widget getContenidonacional(ResponsiveUtil responsive) {
    return Form(
      key: controller.formKeyNacional,
      child: Column(
        children: [
          const Divider(height: 20.0, color: Colors.transparent),
          _TxtCedula(responsive),
          Obx(
            () =>
                controller.cedulaLista.isTrue
                    ? getCampos(responsive)
                    : Container(),
          ),
        ],
      ),
    );
  }

  AppBar getAppBar(String titleAppBar) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06245B), Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      title: Text(
        titleAppBar,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 30,
              color: Colors.white,
              tooltip: 'Atrás',
              onPressed: () => Get.back(),
            ),
          );
        },
      ),
    );
  }

  Widget getCampos(ResponsiveUtil responsive) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const Divider(height: 10.0, color: Colors.transparent),
            _TxtPrimerNombre(responsive),
            const Divider(height: 5.0, color: Colors.transparent),
            controller.segundoNombre
                ? _TxtPrimerNombre2(responsive)
                : Container(),
            const Divider(height: 5.0, color: Colors.transparent),
            const Text('Ingrese sus Apellidos'),
            const Divider(height: 5.0, color: Colors.transparent),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TxtPrimerApellido1(responsive),
                _TxtPrimerApellido2(responsive),
              ],
            ),
            Divider(height: 10.0, color: Colors.transparent),
            _TxtCelular(responsive),
            Divider(height: 10.0, color: Colors.transparent),
            _TxtMail(responsive),
            Divider(height: 10.0, color: Colors.transparent),
            Column(children: <Widget>[wgFoto(responsive), _btnRegistrar()]),
          ],
        ),
      ),
    );
  }

  Widget _btnRegistrar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5.0,
        onPressed: () => controller.registrarUsuario(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueGrey[100],
        child: Text(
          'REGISTRARSE',
          style: TextStyle(
            color: AppConfig.colorBarras,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget myTextFormField({
    required ValueChanged<String> onChanged,
    int maxLength = 0,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required TextInputType keyboardType,
    required String labelText,
    required String hintText,
    required IconData iconData,
  }) {
    Widget wg = SizedBox(
      height: 68.0,
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(iconData, color: const Color(0xFF06245B)),
          border: OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
      ),
    );

    if (maxLength > 0) {
      wg = Container(
        height: 68.0,
        child: TextFormField(
          onChanged: onChanged,
          maxLength: maxLength,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            icon: Icon(iconData, color: const Color(0xFF06245B)),
            border: OutlineInputBorder(),
            labelText: labelText,
            hintText: hintText,
            suffixStyle: TextStyle(color: Colors.green),
          ),
          maxLines: 1,
        ),
      );
    }

    return wg;
  }

  Widget _TxtCedula(ResponsiveUtil res) {
    return Container(
      height: 68.0,
      child: TextFormField(
        onChanged: (value) {
          if (value.length >= 1 && value.length == 10) {
            print(value);
            controller.controllerCedula.text = value;
            controller.cedulaLista.value = true;
          } else {
            controller.cedulaLista.value = false;
          }
        },
        maxLength: 10,
        controller: controller.controllerCedula,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.payment, color: const Color(0xFF06245B)),
          border: OutlineInputBorder(),
          labelText: 'Cédula',
          hintText: 'Ingrese su número de cédula',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _TxtPrimerNombre(ResponsiveUtil res) {
    return Container(
      height: 65.0,
      child: TextFormField(
        controller: controller.controllerPrimerNombre,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Primer Nombre',
          hintText: 'Ingrese su primer nombre',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
        validator: (value) {
          if (value!.isNotEmpty) {
            controller.controllerPrimerNombre.text = value;
            return null;
          }
          return 'Ingrese su Primer Nombre';
        },
      ),
    );
  }

  Widget _TxtPrimerNombre2(ResponsiveUtil res) {
    return Container(
      height: 65.0,
      child: TextFormField(
        controller: controller.controllerPrimerNombre2,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Segundo Nombre',
          hintText: 'Ingrese su segundo nombre',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
        validator: (value) {
          if (value!.isNotEmpty) {
            controller.controllerPrimerNombre2.text = value;
            return null;
          }
          return 'Ingrese su Segundo Nombre';
        },
      ),
    );
  }

  Widget _TxtPrimerApellido1(ResponsiveUtil res) {
    return Container(
      width: res.anchoP(42),
      height: 65.0,
      child: TextFormField(
        controller: controller.controllerApellido1,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Apellido 1',
          hintText: 'Apellido 1',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
        validator: (value) {
          if (value!.isNotEmpty) {
            controller.controllerApellido1.text = value;
            return null;
          }
          return 'Ingrese su Primer Apellido';
        },
      ),
    );
  }

  Widget _TxtPrimerApellido2(ResponsiveUtil res) {
    return Container(
      width: res.anchoP(42),
      height: 65.0,
      child: TextFormField(
        controller: controller.controllerApellido2,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Apellido 2',
          hintText: 'Apellido 2',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
        validator: (value) {
          if (value!.isNotEmpty) {
            controller.controllerApellido2.text = value;
            return null;
          }
          return 'Ingrese su Segundo Apellido';
        },
      ),
    );
  }

  Widget _TxtCelular(ResponsiveUtil res) {
    return Container(
      height: 68.0,
      child: TextFormField(
        controller: controller.controllerContacto,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          icon: Icon(Icons.contact_phone, color: const Color(0xFF06245B)),
          border: OutlineInputBorder(),
          labelText: 'Número de Contacto',
          hintText: 'Número de Contacto',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _TxtMail(ResponsiveUtil res) {
    return Container(
      height: 68.0,
      child: TextFormField(
        controller: controller.controllerCorreo,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          icon: Icon(Icons.email, color: const Color(0xFF06245B)),
          border: OutlineInputBorder(),
          labelText: 'Email de Contacto',
          hintText: 'Email de Contacto',
          suffixStyle: TextStyle(color: Colors.green),
        ),
        maxLines: 1,
        validator: (value) {
          controller.emailValidator(value!);
          return null;
        },
      ),
    );
  }

  Widget wgFoto(ResponsiveUtil responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TituloTextWidget(title: "Seleccione una Imagen de Perfil"),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            controller.mGaleryCameraModel.value = await PhotoHelper.getDesingPictureGaleryOrCamera(
              initPeticion: (value) {
                controller.peticionServerState(value);

              },
              titleImg: "Foto Perfil",
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
                Icon(Icons.add_a_photo, color: const Color(0xFF06245B)),
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
                        height: responsive.altoP(20.0),
                        width: responsive.altoP(20.0),
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
