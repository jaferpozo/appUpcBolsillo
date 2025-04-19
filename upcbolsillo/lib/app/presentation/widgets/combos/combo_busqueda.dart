part of '../custom_widgets.dart';

class ComboBusqueda<T> extends StatefulWidget {


  final String title;
  final ValueChanged<T?>? complete;
  final List<T> datos;
  final String hint;
  final String searchHint;
  final T? selectValue;
  final IconData? icon;
  final String? imgUrl;
  final bool showClearButton;
  final GlobalKey? openDropDownProgKey;
  final String? textSeleccioneUndato;

  final String? Function(T?)? validator;
  final String Function(T)?
      displayField; // Callback para determinar qué mostrar
  final void Function(T)? onChanged;

  const ComboBusqueda({
    Key? key,
    this.complete,
    required this.datos,
    this.title = '',
    this.hint = 'Seleccione...',
    required this.searchHint,
    this.selectValue,
    this.icon,
    this.showClearButton = true,
    this.openDropDownProgKey,
    this.textSeleccioneUndato,
    this.imgUrl,
    this.validator,
    this.displayField,
    this.onChanged,
  }) : super(key: key);

  @override
  _ComboBusquedaState<T> createState() => _ComboBusquedaState<T>();
}

class _ComboBusquedaState<T> extends State<ComboBusqueda<T>> {

  late bool showX; // Declaramos como una variable de estado

  final _userEditTextController = TextEditingController(text: '');

  @override
  void initState() {
    showX = false; // Inicializamos en false
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget wgComboBusqueda = DropdownSearch<T>(
      selectedItem: widget.selectValue,
      compareFn: (item, selectedItem) => item == selectedItem,
      validator: (v) {
        print("haolala");
        return v == null ? "EL ${widget.title} Es requerido" : null;
      },
      key: widget.openDropDownProgKey,
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(isVisible: showX, color: Colors.red),
        //lo paso en falkse xq ya esta diseñado xq no encontraba formada de captuyra el evento de limpiar
        // lo que fue seleccionado
      ),
      popupProps: PopupPropsMultiSelection.dialog(
        showSelectedItems: true,
        disableFilter: false,
        itemBuilder: (context, item, isSelected, l) =>
            _customDesingDataPopop(context, item, isSelected, l),
        showSearchBox: true,
        searchFieldProps: getBusquedaPopup(),
        dialogProps: DialogProps(
          backgroundColor: Colors.white,
          barrierDismissible: true, // Permite cerrar tocando fuera
          insetPadding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 20), // Márgenes del diálogo
          actionsAlignment:
              MainAxisAlignment.end, // Alinea la acción a la derecha
          actionsPadding: EdgeInsets.only(
              top: 10, right: 10), // Posiciona el botón arriba a la derecha
        ),
      ),
      itemAsString: (item) {
        // Usa el callback displayField para obtener el texto dinámico
        if (item != null && widget.displayField != null) {
          return widget.displayField!(item);
        }
        return '';
      },
      dropdownBuilder: (context, selectedItem) =>
          _customDropDownExample(context, selectedItem),
      items: (filter, infiniteScrollProps) => widget.datos,
      onChanged: (value) {
        print("cambiaa");
        if (widget.complete != null) {
          widget.complete!(value);
        }
      },
    );

    return Row(
      children: [
        Expanded(
          child: TituloTextWidget(title: widget.searchHint),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(flex: 3, child: wgComboBusqueda)
      ],
    );
  }

  TextFieldProps getBusquedaPopup() {
    return TextFieldProps(
      controller: _userEditTextController,
      decoration: InputDecoration(
        suffixIcon: Row(
          mainAxisSize:
              MainAxisSize.min, // Ajusta el tamaño para evitar expandir
          children: [
         /*
         TODO: comentado
         IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _userEditTextController.clear(); // Limpia el campo de texto
              },
            ),*/
         IconButton(
              icon:
                  Icon(Icons.close, color: Colors.red), // Botón "X" para cerrar
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
        labelText: widget.searchHint,
      ),
    );
  }

  Widget _customDropDownExample(BuildContext context, T? item) {
    final responsive = ResponsiveUtil();

    Widget msjSelectDato = Text(
      widget.textSeleccioneUndato ?? "Seleccione un dato",
      style: TextStyle(color: Colors.red, fontSize: responsive.diagonalP(1)),
    );

    if (item == null) {
      return msjSelectDato;
    } else {
      if (widget.displayField!(item).isEmpty) {

        if (showX) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                showX = false;
              });
            }
          });
        }


        return msjSelectDato;
      }

      if (!showX) {
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              showX = true;
            });
          }
        });
      }


      return Text(
        widget.displayField!(item),
        textAlign: TextAlign.center, // Justifica el texto
        style: TextStyle(
          fontSize: responsive.diagonalP(1.2),
        ),
      );


    }
  }

  Widget _customDesingDataPopop(
      BuildContext context, T? item, bool v, bool isSelected) {
    final responsive = ResponsiveUtil();

    print("isSelected ${isSelected} ybb= ${v}");

    Widget msjSelectDato = ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        widget.textSeleccioneUndato ?? "Seleccione un dato",
        style: TextStyle(color: Colors.red, fontSize: responsive.diagonalP(1)),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue,
            ),
      child: (item == null)
          ? msjSelectDato
          : widget.displayField!(item).length == 0
              ? msjSelectDato
              : getDesing(
                  colorTexto: isSelected ? Colors.white : Colors.black,
                  titulo: widget.displayField!(item),
                  icon: widget.icon,
                  iconUrl: widget.imgUrl,
                  isSelect: isSelected),
    );
  }

  Widget getOnlyDesing(
      {required Widget icon,
      String titulo = '',
      Color colorTexto = Colors.black}) {
    final responsive = ResponsiveUtil();
    return Column(
      children: [
        Row(
          children: [
            icon,
            Flexible(
                child: Text(
              titulo,
              style: TextStyle(
                fontSize: responsive.diagonalP(1.2),
                color: colorTexto,
              ),
            )),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 1,
          color: Colors.black38,
        )
      ],
    );
  }

  Widget getDesing(
      {bool isSelect = false,
      IconData? icon,
      String titulo = '',
      bool selected = false,
      String? iconUrl,
      Color colorTexto = Colors.black}) {
    Widget _icon = getIcon(icon: icon, isSelecc: isSelect);

    return getOnlyDesing(icon: _icon, titulo: titulo, colorTexto: colorTexto);

  }

  getIcon({IconData? icon, bool isSelecc = false}) {


    Widget wg=  icon != null
        ? Icon(
      icon,
      color: AppColors.colorBotones,

    )
        : Icon(
        Icons.description,
        color: AppColors.colorBotones,);

    if (isSelecc) {
      wg= Icon(
        Icons.check_circle,
        color: Colors.white,

      );
    }
    return Container(
      padding: EdgeInsets.all(5),
      child: wg,);





  }
}
