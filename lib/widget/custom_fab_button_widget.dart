import 'package:flutter/material.dart';

/// FAB Type Enum
enum FabType {
  standard,
  extended,
  menu,
}

/// FAB Menu Item Model
class FabMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  FabMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Main Custom FAB Widget
class CustomFAB extends StatelessWidget {
  final FabType type;
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final List<FabMenuItem>? menuItems;

  const CustomFAB({
    super.key,
    required this.type,
    required this.icon,
    this.label,
    this.onPressed,
    this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case FabType.standard:
        return FloatingActionButton(
          onPressed: onPressed,
          child: Icon(icon),
        );

      case FabType.extended:
        return FloatingActionButton.extended(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label ?? ''),
        );

      case FabType.menu:
        return _FabMenu(menuItems: menuItems ?? []);

      }
  }
}

/// FAB Menu Implementation
class _FabMenu extends StatefulWidget {
  final List<FabMenuItem> menuItems;

  const _FabMenu({required this.menuItems});

  @override
  State<_FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<_FabMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    _isOpen ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ...widget.menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Positioned(
            bottom: 70.0 * (index + 1),
            right: 0,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.easeOut,
              ),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    item.onTap();
                    _toggle(); // auto close
                  },
                  icon: Icon(item.icon),
                  label: Text(item.label),
                  heroTag: null, // avoid hero conflict
                ),
              ),
            ),
          );
        }),
        FloatingActionButton(
          onPressed: _toggle,
          child: Icon(_isOpen ? Icons.close : Icons.menu),
        ),
      ],
    );
  }
}
