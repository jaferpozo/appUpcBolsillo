part of 'custom_widgets.dart';
class ModuleCard extends StatefulWidget {
  final String title;
  final String? base64Img;
  final VoidCallback onTap;
  const ModuleCard({
    Key? key,
    required this.title,
    this.base64Img,
    required this.onTap,
  }) : super(key: key);

  @override
  _ModuleCardState createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.95 : 1.0;
    final elevation = _pressed ? 4.0 : 12.0;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(scale),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.grey.shade300,
          elevation: elevation,
          shadowColor:  Colors.black,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen o icono
                SizedBox(
                  width: 90,
                  height: 90,
                  child: ClipOval(
                    child: widget.base64Img == null
                        ? Icon(Icons.folder, size: 60, color: Colors.indigo)
                        : Image.memory(
                      base64Decode(widget.base64Img!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Texto
                Text(
                  widget.title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF06245B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
