import 'package:flutter/material.dart';

class CustomProgressSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color trackColor;
  final Color fillColor;
  final Color knobColor;
  final double minValue;
  final double maxValue;
  final double cornerRadius;
  final double height;

  const CustomProgressSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.trackColor = const Color(0xFF7A7D7A),
    this.fillColor = const Color(0xFFFFBB00),
    this.knobColor = const Color(0xFFB4B4B4),
    required this.minValue,
    required this.maxValue,
    this.cornerRadius = 6.0,
    required this.height,
  });

  @override
  _CustomProgressSliderState createState() => _CustomProgressSliderState();
}

class _CustomProgressSliderState extends State<CustomProgressSlider> {
  bool isKnobMoved = false;

  void _updateValueFromPosition(double x, double trackWidth) {
    double fraction = (x / trackWidth).clamp(0.0, 1.0);
    double value =
        widget.minValue + fraction * (widget.maxValue - widget.minValue);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double trackWidth = constraints.maxWidth;
        double knobWidth = 18.0;
        double knobHeight = 35.0;

        double range = widget.maxValue - widget.minValue;
        double normalizedValue = (widget.value - widget.minValue) / range;

        double left = normalizedValue * (trackWidth - knobWidth);
        double fillWidth = normalizedValue * trackWidth;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            setState(() {
              isKnobMoved = true;
            });
            _updateValueFromPosition(details.localPosition.dx, trackWidth);
          },
          onHorizontalDragUpdate: (details) {
            _updateValueFromPosition(details.localPosition.dx, trackWidth);
          },
          onHorizontalDragEnd: (d) {
            setState(() {
              isKnobMoved = false;
            });
          },
          child: SizedBox(
            height: knobHeight,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: widget.height,
                    width: trackWidth,
                    decoration: BoxDecoration(
                      color: widget.trackColor,
                      borderRadius: BorderRadius.circular(widget.cornerRadius),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: widget.height,
                    width: fillWidth,
                    decoration: BoxDecoration(
                      color: widget.fillColor,
                      borderRadius: BorderRadius.circular(widget.cornerRadius),
                    ),
                  ),
                ),
                Positioned(
                  left: left,
                  top: 0,
                  child: Container(
                    width: knobWidth,
                    height: knobHeight,
                    decoration: BoxDecoration(
                      color:
                          isKnobMoved
                              ? const Color.fromARGB(255, 251, 202, 54)
                              : widget.knobColor,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 37, 37, 37),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
