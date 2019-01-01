import 'package:flutter/material.dart';

class LabelAlignment {
  int labelAlignment;

  LabelAlignment(this.labelAlignment);

  static const leftTop = 0;
  static const leftBottom = 1;
  static const rightTop = 2;
  static const rightBottom = 3;
}

class LabelView extends StatefulWidget {
  final Size size;
  final Color labelColor;
  final labelAlignment;

  LabelView(this.size, this.labelColor, this.labelAlignment);

  @override
  State<StatefulWidget> createState() {
    return LabelViewState();
  }
}

class LabelViewState extends State<LabelView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      color: Colors.grey,
      child: CustomPaint(
        size: widget.size,
        painter: LabelViewPainter(widget.labelColor, widget.labelAlignment),
      ),
    );
  }
}

class LabelViewPainter extends CustomPainter {
  var labelColor;
  var labelAlignment;
  var _paint;

  LabelViewPainter(this.labelColor, this.labelAlignment) {
    _paint = new Paint()
      ..color = labelColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var drawSize = size.height > size.width ? size.width / 2 : size.height / 2;
    Path path = new Path();

    switch (labelAlignment) {
      case LabelAlignment.leftTop:
        path.lineTo(0, drawSize);
        path.lineTo(drawSize, 0);

        break;
      case LabelAlignment.leftBottom:
        path.moveTo(0, size.height - drawSize);
        path.lineTo(drawSize, size.height);
        path.lineTo(0, size.height);

        break;
      case LabelAlignment.rightTop:
        path.moveTo(size.width - drawSize, 0);
        path.lineTo(size.width, 0);
        path.lineTo(size.width, drawSize);

        break;
      case LabelAlignment.rightBottom:
        path.moveTo(size.width, size.height);
        path.lineTo(size.width - drawSize, size.height);
        path.lineTo(size.width, size.height - drawSize);

        break;
      default:
        path.lineTo(0, drawSize);
        path.lineTo(drawSize, 0);
        break;
    }

    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
