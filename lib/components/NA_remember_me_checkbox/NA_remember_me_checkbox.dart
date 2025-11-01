import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final String label;

  const RememberMeCheckbox({
    Key? key,
    this.initialValue = false,
    required this.onChanged,
    this.label = "Remember Me",
  }) : super(key: key);

  @override
  _RememberMeCheckboxState createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
            widget.onChanged(isChecked);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // yuvarlaklık
          ),
          side: BorderSide(
            color: Colors.blue, // kenar rengi
            width: 2,           // kenar kalınlığı
          ),
          activeColor: Colors.blue,
          checkColor: Colors.white,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
            });
            widget.onChanged(isChecked);
          },
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline
            ),
          ),
        ),
      ],
    );
  }
}
