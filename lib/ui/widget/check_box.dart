// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  String title;
  bool state;
  // Color color;
  CheckBox({
    super.key,
    required this.title,
    this.state = false,
    // this.color = Colors.red
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        widget.state = true;

        return Colors.teal;
      }

      return Colors.teal;
    }

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
              widget.state = true;

              // widget.color = Colors.teal;
            });
          },
        ),
        Text(widget.title)
      ],
    );
  }
}
