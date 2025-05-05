import 'package:flutter/material.dart';

class CustomProgressSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color trackColor;
  final Color fillColor;
  final Color knobColor;
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
    this.maxValue = 10.0,
    this.cornerRadius = 6.0,
    required this.height,
  });

  @override
  _CustomProgressSliderState createState() => _CustomProgressSliderState();
}

class _CustomProgressSliderState extends State<CustomProgressSlider> {
  void _updateValueFromPosition(double x, double trackWidth) {
    // Clamp the fraction between 0 and 1 based on the track width
    double fraction = (x / trackWidth).clamp(0.0, 1.0);
    double value = fraction * widget.maxValue;
    widget.onChanged(value);
  }

  bool isknobmoved = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double trackWidth = constraints.maxWidth;
        double knobWidth = 18.0;

        // Calculate knob position and fill width based on the value
        double left =
            (widget.value / widget.maxValue) * (trackWidth - knobWidth);
        double fillWidth = (widget.value / widget.maxValue) * trackWidth;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,

          onTapDown: (details) {
            setState(() {
              isknobmoved = true;
            });
            _updateValueFromPosition(details.localPosition.dx, trackWidth);
          },
          onHorizontalDragUpdate: (details) {
            _updateValueFromPosition(details.localPosition.dx, trackWidth);
          },
          onHorizontalDragEnd: (d) {
            setState(() {
              isknobmoved = false;
            });
          },
          child: SizedBox(
            height: widget.height,
            child: Stack(
              children: [
                // Outer Track
                Center(
                  child: Container(
                    height: widget.height,
                    width: trackWidth,
                    decoration: BoxDecoration(
                      color: widget.trackColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                // Fill
                Container(
                  height: widget.height,
                  width: fillWidth,
                  decoration: BoxDecoration(
                    color: widget.fillColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                // Draggable Knob
                Positioned(
                  left: left,
                  child: Container(
                    width: knobWidth,
                    height: widget.height,

                    decoration: BoxDecoration(
                      color:
                          isknobmoved
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
