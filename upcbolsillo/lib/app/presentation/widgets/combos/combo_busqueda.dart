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
  final String Function(T)? displayField;
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

class _ComboBusquedaState<T> extends State<ComboBusqueda<T>> with SingleTickerProviderStateMixin {
  late bool showX;
  final _userEditTextController = TextEditingController(text: '');
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    showX = false;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtil();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Delito",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.diagonalP(1.9),
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownSearch<T>(
              selectedItem: widget.selectValue,
              compareFn: (item, selectedItem) => item == selectedItem,
              validator: widget.validator ??
                      (v) {
                    return v == null ? "El ${widget.title} es requerido" : null;
                  },
              key: widget.openDropDownProgKey,
              suffixProps: DropdownSuffixProps(
                clearButtonProps: ClearButtonProps(
                  isVisible: showX,
                  color: Colors.red,
                ),
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
                  barrierDismissible: true,
                  insetPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  actionsAlignment: MainAxisAlignment.end,
                  actionsPadding: const EdgeInsets.only(top: 10, right: 10),
                ),
              ),
              itemAsString: (item) =>
              (item != null && widget.displayField != null)
                  ? widget.displayField!(item)
                  : '',
              dropdownBuilder: (context, selectedItem) =>
                  _customDropDownExample(context, selectedItem),
              items: (filter, infiniteScrollProps) => widget.datos,
              onChanged: (value) {
                if (widget.complete != null) {
                  widget.complete!(value);
                }
                if (widget.onChanged != null && value != null) {
                  widget.onChanged!(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  TextFieldProps getBusquedaPopup() {
    return TextFieldProps(
      controller: _userEditTextController,
      decoration: InputDecoration(
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
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
      style: TextStyle(color: Colors.red, fontSize: responsive.diagonalP(1.5)),
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
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: responsive.diagonalP(1.8)),
      );
    }
  }

  Widget _customDesingDataPopop(
      BuildContext context, T? item, bool v, bool isSelected) {
    final responsive = ResponsiveUtil();

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
          : widget.displayField!(item).isEmpty
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
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Container(height: 1, color: Colors.black38),
      ],
    );
  }

  Widget getDesing({
    bool isSelect = false,
    IconData? icon,
    String titulo = '',
    bool selected = false,
    String? iconUrl,
    Color colorTexto = Colors.black,
  }) {
    Widget _icon = getIcon(icon: icon, isSelecc: isSelect);
    return getOnlyDesing(icon: _icon, titulo: titulo, colorTexto: colorTexto);
  }

  Widget getIcon({IconData? icon, bool isSelecc = false}) {
    Widget wg = icon != null
        ? Icon(icon, color: AppColors.colorBotones)
        : Icon(Icons.description, color: AppColors.colorBotones);

    if (isSelecc) {
      wg = Icon(Icons.check_circle, color: Colors.white);
    }
    return Container(padding: EdgeInsets.all(5), child: wg);
  }
}
