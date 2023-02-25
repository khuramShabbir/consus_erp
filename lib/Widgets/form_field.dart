import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFormField extends StatefulWidget {
  final String? labelText;
  final String? label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool isPasswordField;
  final TextEditingController? controller;
  final bool? enabled;
  final double? height;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool isOutlineBorder;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autoValidateMode;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final double? bottomPadding;
  final Widget? prefixIcon;
  final VoidCallback? onEditingComp;
  final bool? isValidatorRequired;

  const AppFormField({
    Key? key,
    this.labelText,
    this.label,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.controller,
    this.enabled = true,
    this.height,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.isOutlineBorder = true,
    this.inputFormatters,
    this.autoValidateMode,
    this.validator,
    this.onChanged,
    this.bottomPadding = 20.0,
    this.prefixIcon,
    this.onEditingComp,
    this.isValidatorRequired = false,
  }) : super(key: key);
  @override
  _AppFormFieldState createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding ?? 0,
      ),
      child: TextFormField(
        autovalidateMode: widget.autoValidateMode,
        validator: widget.validator ??
            (widget.isValidatorRequired != null && widget.isValidatorRequired!
                ? (val) {
                    if (val!.isEmpty) return 'Required *';
                    return null;
                  }
                : null),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color(0xFFA8ADB7),
          ),
          prefixIcon: widget.prefixIcon,
          enabledBorder: widget.isOutlineBorder ? outLineBorder : underlineBorder,
          border: widget.isOutlineBorder ? outLineBorder : underlineBorder,
          suffixIcon: widget.isPasswordField ? _buildPasswordFieldVisibilityToggle() : null,
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        keyboardType: widget.keyboardType,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: widget.isPasswordField ? _obscureText : false,
        controller: widget.controller,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComp,
      ),
    );
  }

  Widget _buildPasswordFieldVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  final outLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.4),
    ),
  );
  final underlineBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.4),
    ),
  );
}
