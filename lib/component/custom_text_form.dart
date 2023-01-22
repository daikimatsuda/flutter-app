import 'package:flutter/material.dart';
import 'package:flutter_dev/validator/validator.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final List<Validator> validators;
  final Function onChange;
  final Function setIsValid;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.validators,
    required this.onChange,
    required this.setIsValid,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  /// エラーテキスト
  String? _errorText;

  /// バリデーションを実施する
  void _validate(String value) {
    widget.onChange(value);
    final result = widget.validators
        .where((validator) => validator.validate(value) == false)
        .toList();
    if (result.isNotEmpty) {
      _errorText = result.first.getMessage();
      widget.setIsValid(false);
    } else {
      _errorText = null;
      widget.setIsValid(true);
    }
  }

  /// エラーによって色をだし分ける
  Color _bindColor() {
    if (_errorText == null) {
      return Colors.grey;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            label: Text(widget.label, style: TextStyle(color: _bindColor())),
          ),
          onChanged: (String value) {
            _validate(value);
          },
        ),
        _errorText != null
            ? Text(
          _errorText!,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.red),
        )
            : const SizedBox()
      ],
    );
  }
}