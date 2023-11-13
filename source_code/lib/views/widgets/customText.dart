import 'package:flutter/cupertino.dart';

class CustomText extends StatefulWidget {
  var text, fontSize, fontWeight, fontFamily, textAlign, color, textDirection;

  CustomText({
    super.key,
    this.text,
    this.fontSize = 12.0,
    this.fontWeight,
    this.textAlign,
    this.color,
    this.textDirection,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight, color: widget.color),
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
    );
  }
}
