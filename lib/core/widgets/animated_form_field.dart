import 'package:flutter/material.dart';
import 'package:rolo/app/themes/themes_data.dart';

class AnimatedFormField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? errorText;
  final bool isRequired;
  final TextInputType keyboardType;
  final int maxLines;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool enabled;

  const AnimatedFormField({
    Key? key,
    required this.label,
    this.hint,
    required this.controller,
    this.errorText,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AnimatedFormField> createState() => _AnimatedFormFieldState();
}

class _AnimatedFormFieldState extends State<AnimatedFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: AppTheme.cardColor,
      end: AppTheme.primaryColor.withOpacity(0.1),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: AppTheme.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentColor,
                    ),
                    children: widget.isRequired
                        ? [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: AppTheme.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        : [],
                  ),
                ),
                const SizedBox(height: 8),
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isFocused = hasFocus;
                    });
                    if (hasFocus) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  },
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    maxLines: widget.maxLines,
                    enabled: widget.enabled,
                    onChanged: widget.onChanged,
                    style: AppTheme.bodyStyle,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      suffixIcon: widget.suffixIcon,
                      fillColor: _colorAnimation.value,
                      errorText: widget.errorText,
                      errorStyle: TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.errorText != null
                              ? AppTheme.errorColor
                              : Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.errorText != null
                              ? AppTheme.errorColor
                              : Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: widget.errorText != null
                              ? AppTheme.errorColor
                              : AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
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
