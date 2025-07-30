import 'package:flutter/material.dart';
import 'package:rolo/app/themes/themes_data.dart';

class AutocompleteField extends StatefulWidget {
  final String label;
  final String? hint;
  final String value;
  final List<String> suggestions;
  final Function(String) onChanged;
  final Function(String) onSelected;
  final String? errorText;
  final bool isRequired;
  final bool enabled;

  const AutocompleteField({
    Key? key,
    required this.label,
    this.hint,
    required this.value,
    required this.suggestions,
    required this.onChanged,
    required this.onSelected,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AutocompleteField> createState() => _AutocompleteFieldState();
}

class _AutocompleteFieldState extends State<AutocompleteField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late TextEditingController _controller;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _removeOverlay(); 

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _slideAnimation.value,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: _slideAnimation.value.clamp(0.0, 1.0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    color: AppTheme.cardColor,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: _buildSuggestionsList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  Widget _buildSuggestionsList() {
    final input = _controller.text.toLowerCase();
    final filteredSuggestions = widget.suggestions
        .where((s) => s.toLowerCase().contains(input))
        .toList();

    if (filteredSuggestions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No suggestions found',
          style: AppTheme.bodyStyle.copyWith(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredSuggestions.length,
      itemBuilder: (context, index) {
        final suggestion = filteredSuggestions[index];
        return InkWell(
          onTap: () {
            widget.onSelected(suggestion);
            _controller.text = suggestion;
            widget.onChanged(suggestion);
            _removeOverlay();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              suggestion,
              style: AppTheme.bodyStyle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
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
          TextFormField(
            enabled: widget.enabled,
            controller: _controller,
            onChanged: (value) {
              widget.onChanged(value);
              if (value.isNotEmpty && !_showSuggestions) {
                setState(() => _showSuggestions = true);
                _showOverlay();
              } else if (value.isEmpty) {
                setState(() => _showSuggestions = false);
                _removeOverlay();
              } else {
                _removeOverlay();
                _showOverlay();
              }
            },
            onTap: () {
              if (_controller.text.isNotEmpty && !_showSuggestions) {
                setState(() => _showSuggestions = true);
                _showOverlay();
              }
            },
            style: AppTheme.bodyStyle,
            decoration: InputDecoration(
              hintText: widget.hint,
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.primaryColor,
              ),
              errorText: widget.errorText,
              errorStyle: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
