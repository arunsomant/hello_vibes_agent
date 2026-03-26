import 'package:flutter/material.dart';

import 'index.dart';
class OtpController extends TextEditingController {
  OtpController({super.text});

  @override
  set selection(TextSelection newSelection) {
    super.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }
}

class OtpWidget extends StatefulWidget {
  const OtpWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  static const String holder = "\u200B";
  final List<OtpController> _controllers = List.generate(
    4,
    (_) => OtpController(text: holder),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  void _onChanged(String value, int index) {
    if (value.isEmpty) {
      _controllers[index].text = holder;
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
      return;
    }

    String digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isNotEmpty) {
      String lastDigit = digits.characters.last;
      _controllers[index].text = holder + lastDigit;
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      _controllers[index].text = holder;
    }
    widget.controller.text = otpValue;
  }

  String get otpValue {
    return _controllers.map((controller) {
      return controller.text.replaceAll(holder, '');
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) => _buildBox(index)),
    );
  }

  Widget _buildBox(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: AppInputText(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        showCursor: true,
        enableInteractiveSelection: false,
        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }
}
