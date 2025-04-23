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
              widget.title,
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
      style: TextStyle(color: AppColors.colorBordecajas, fontSize: responsive.diagonalP(1.6)),
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
      BuildContext context,
      T? item,
      bool _,          // parámetro no usado
      bool isSelected) {
    final resp = ResponsiveUtil();
    if (item == null || widget.displayField!(item).isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          widget.textSeleccioneUndato ?? 'Seleccione un dato',
          style: TextStyle(
            color: Colors.red,
            fontSize: resp.diagonalP(1.2),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Item normal con animación y feedback visual
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ?  AppColors.colorBordecajas
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ?   Colors.black
              : AppColors.colorBordecajas,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColors.colorBordecajas,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ]
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
          onTap: () {

          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: resp.anchoP(2),
              vertical: resp.altoP(1),
            ),
            child: Row(
              children: [
                // Icono de check o genérico
                Container(
                  padding: EdgeInsets.all(resp.anchoP(0.8)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white
                        : Colors.grey.shade300,
                  ),
                  child: Icon(
                    isSelected ? Icons.check : (widget.icon ?? Icons.description),
                    size: resp.diagonalP(2),
                    color: isSelected ? Colors.black : AppColors.colorBordecajas,
                  ),
                ),
                SizedBox(width: resp.anchoP(2)),
                // Texto del ítem
                Expanded(
                  child: Text(
                    widget.displayField!(item),
                    style: TextStyle(
                      fontSize: resp.diagonalP(1.6),
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getOnlyDesing({
    required Widget icon,
    required String titulo,
    Color colorTexto = Colors.black,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    final responsive = ResponsiveUtil();
    final bgColor = selected ? Colors.blue.withOpacity(0.1) : Colors.transparent;
    final textColor = selected ? Colors.blue : colorTexto;
    final borderColor = selected ? Colors.black87 : Colors.grey.shade300;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.altoP(1.2),
            horizontal: responsive.anchoP(3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon,
                  SizedBox(width: responsive.anchoP(1.5)),
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        fontSize: responsive.diagonalP(1.5),
                        color: textColor,
                        fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.altoP(1)),
              Container(height: 1, color: borderColor),
            ],
          ),
        ),
      ),
    );
  }

}
