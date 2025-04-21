import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../app/core/utils/my_date.dart';
import '../values/app_images.dart';

class PhotoHelper {
  static Future<GaleryCameraModel?> getDesingPictureGaleryOrCamera({
    required String titleImg,
    required ValueChanged<bool> initPeticion,
  }) async {
    final Completer<GaleryCameraModel?> completer = Completer();

    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      desc: 'Elige una imagen de la galería o toma una foto con la cámara',
      customHeader: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Image.asset(
          AppImages.imgFoto,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
      btnCancel: _animatedButton(
        icon: Icons.photo_library,
        text: "Galería",
        color: Colors.blue.shade900,
        onTap: () async {
          Get.back();
          initPeticion(true);
          final data = await getImageGallery(titleImg);
          initPeticion(false);
          completer.complete(data);
        },
      ),
      btnOk: _animatedButton(
        icon: Icons.camera_alt,
        text: "Cámara",
        color: Colors.blue.shade900,
        onTap: () async {
          Get.back();
          initPeticion(true);
          final data = await getImageCamera(titleImg);
          initPeticion(false);
          completer.complete(data);
        },
      ),
      dismissOnTouchOutside: true,
      showCloseIcon: true,
    ).show();

    return completer.future;
  }

  static Widget _animatedButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(text,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  static Future<GaleryCameraModel?> getImageGallery(String title) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    return getImagenResourse(title: title, imageFile: imageFile);
  }

  static Future<GaleryCameraModel?> getImageCamera(String title) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    return getImagenResourse(title: title, imageFile: imageFile);
  }

  static Future<GaleryCameraModel?> getImagenResourse({
    required String title,
    XFile? imageFile,
  }) async {
    if (imageFile == null) return null;
    final bytes = await File(imageFile.path).readAsBytes();
    final image = Img.decodeImage(bytes);
    if (image == null) return null;

    return getResizeImg(title: title, image: image, tamImg: 900);
  }

  static Future<GaleryCameraModel> getResizeImg({
    required String title,
    required Img.Image image,
    required int tamImg,
  }) async {
    int alto = image.height;
    int ancho = image.width;
    double relacion = ancho / alto;

    if (alto > tamImg || ancho > tamImg) {
      if (alto > ancho) {
        ancho = (tamImg * relacion).round();
        alto = tamImg;
      } else {
        alto = (tamImg / relacion).round();
        ancho = tamImg;
      }
    }

    final resized = Img.copyResize(image, height: alto, width: ancho);
    final dir = await getTemporaryDirectory();
    final path = dir.path;
    final name = "img_${title}_${Math.Random().nextInt(99999)}_${MyDate.getFechaActual.replaceAll(" ", "_")}.jpg";
    final file = File("$path/$name")..writeAsBytesSync(Img.encodeJpg(resized, quality: 100));

    return GaleryCameraModel(
      title: title,
      tamImg: tamImg,
      nombreImg: name,
      imageFile: file,
      image: image,
      isHorizontal: ancho >= alto,
      isVertical: alto > ancho,
    );
  }

  static Uint8List? convertStringToUint8List(String? fotoString) {
    try {
      if (fotoString != null && fotoString.isNotEmpty) {
        return base64Decode(fotoString.split(',').last);
      }
    } catch (e) {
      log('Error al convertir imagen: $e');
    }
    return null;
  }
}

class GaleryCameraModel {
  final String title;
  final int tamImg;
  final String nombreImg;
  final File imageFile;
  final Img.Image image;
  final bool isHorizontal;
  final bool isVertical;

  GaleryCameraModel({
    required this.title,
    required this.tamImg,
    required this.nombreImg,
    required this.imageFile,
    required this.image,
    this.isVertical = false,
    this.isHorizontal = false,
  });
}
