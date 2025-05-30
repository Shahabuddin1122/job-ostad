import 'package:client/models/inputType.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/utils/constants.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final InputType inputType;

  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  final List<String>? dropdownItems;
  final String? dropdownValue;
  final void Function(String?)? onDropdownChanged;

  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;

  const CustomInput({
    Key? key,
    required this.label,
    this.controller,
    this.inputType = InputType.text,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.showCounter = false,
    this.obscureText = false,
    this.inputFormatters,
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.labelColor,
    this.textColor,
    this.borderRadius = 12.0,
    this.contentPadding,
    this.textStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _isPasswordVisible = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label,
              style:
                  widget.labelStyle ??
                  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.labelColor ?? TEXT,
                  ),
            ),
          ),

        widget.inputType == InputType.dropdown
            ? _buildDropdownField()
            : _buildTextField(),

        if (widget.helperText != null)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              widget.helperText!,
              style: TextStyle(
                fontSize: 12,
                color: (widget.textColor ?? TEXT).withOpacity(0.6),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText:
          widget.inputType == InputType.password && !_isPasswordVisible,
      maxLines: widget.inputType == InputType.multiline
          ? null
          : widget.maxLines,
      maxLength: widget.maxLength,
      keyboardType: _getKeyboardType(),
      textInputAction: _getTextInputAction(),
      inputFormatters: widget.inputFormatters ?? _getDefaultInputFormatters(),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      style:
          widget.textStyle ??
          TextStyle(
            color: widget.enabled ? (widget.textColor ?? TEXT) : DISABLE,
            fontSize: 16,
          ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: (widget.textColor ?? TEXT).withOpacity(0.5),
          fontSize: 16,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: _isFocused
                    ? (widget.focusedBorderColor ?? PRIMARY_COLOR)
                    : (widget.enabled ? PRIMARY_COLOR : DISABLE),
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
        filled: true,
        fillColor: widget.enabled
            ? (widget.fillColor ?? BACKGROUND)
            : DISABLE.withOpacity(0.1),
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _buildBorder(
          widget.borderColor ?? BORDER_COLOR.withOpacity(0.2),
        ),
        enabledBorder: _buildBorder(
          widget.borderColor ?? BORDER_COLOR.withOpacity(0.2),
        ),
        focusedBorder: _buildBorder(
          widget.focusedBorderColor ?? PRIMARY_COLOR,
          width: 2.0,
        ),
        errorBorder: _buildBorder(INCORRECT),
        focusedErrorBorder: _buildBorder(INCORRECT, width: 2.0),
        disabledBorder: _buildBorder(DISABLE.withOpacity(0.3)),
        counterStyle: TextStyle(
          color: (widget.textColor ?? TEXT).withOpacity(0.6),
          fontSize: 12,
        ),
        counterText: widget.showCounter ? null : '',
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: widget.dropdownValue,
      onChanged: widget.enabled ? widget.onDropdownChanged : null,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: (widget.textColor ?? TEXT).withOpacity(0.5),
          fontSize: 16,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.enabled ? PRIMARY_COLOR : DISABLE,
              )
            : null,
        filled: true,
        fillColor: widget.enabled
            ? (widget.fillColor ?? BACKGROUND)
            : DISABLE.withOpacity(0.1),
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _buildBorder(
          widget.borderColor ?? BORDER_COLOR.withOpacity(0.2),
        ),
        enabledBorder: _buildBorder(
          widget.borderColor ?? BORDER_COLOR.withOpacity(0.2),
        ),
        focusedBorder: _buildBorder(
          widget.focusedBorderColor ?? PRIMARY_COLOR,
          width: 2.0,
        ),
        errorBorder: _buildBorder(INCORRECT),
        focusedErrorBorder: _buildBorder(INCORRECT, width: 2.0),
        disabledBorder: _buildBorder(DISABLE.withOpacity(0.3)),
      ),
      dropdownColor: widget.fillColor ?? BACKGROUND,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: widget.enabled ? PRIMARY_COLOR : DISABLE,
      ),
      items: widget.dropdownItems?.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style:
                widget.textStyle ??
                TextStyle(color: widget.textColor ?? TEXT, fontSize: 16),
          ),
        );
      }).toList(),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.inputType == InputType.password) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: _isFocused
              ? (widget.focusedBorderColor ?? PRIMARY_COLOR)
              : (widget.enabled ? PRIMARY_COLOR : DISABLE),
        ),
        onPressed: widget.enabled
            ? () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }
            : null,
      );
    }
    return widget.suffixIcon;
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.inputType) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.number:
        return TextInputType.number;
      case InputType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    if (widget.inputType == InputType.multiline) {
      return TextInputAction.newline;
    }
    return TextInputAction.next;
  }

  List<TextInputFormatter>? _getDefaultInputFormatters() {
    switch (widget.inputType) {
      case InputType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(15),
        ];
      case InputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}

// Validation helper methods
class InputValidators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter ${fieldName ?? 'this field'}';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Field'} must not exceed $maxLength characters';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase and number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
