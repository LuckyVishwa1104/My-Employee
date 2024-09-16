import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  final Function(String) onCompleted;

  const OtpTextField({required this.onCompleted, super.key});

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<bool> _hasFocus;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) => TextEditingController());
    _focusNodes = List.generate(4, (index) => FocusNode());
    _hasFocus = List.generate(4, (index) => false);

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].addListener(() => _onTextChanged(i));
      _focusNodes[i].addListener(() {
        setState(() {
          _hasFocus[i] = _focusNodes[i].hasFocus;
        });
      });
    }
  }

  void _onTextChanged(int index) {
    String text = _controllers[index].text;
    if (text.length == 1) {
      if (index < _controllers.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        widget.onCompleted(_controllers.map((c) => c.text).join());
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.shade200,
          border: Border.all(
            color: Colors.grey.shade500,
          ),
        ),
        child: SizedBox(
          width: 200,
          child: Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '', // Hide the character counter
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _hasFocus[index]
                              ? const Color.fromARGB(255, 54, 52, 52)
                              : Colors.grey.shade500,
                          width: 1.2,
                        ),
                      ),
                    ),
                    onChanged: (text) => _onTextChanged(index),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
