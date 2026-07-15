import 'package:flutter/material.dart';

/// Rounded-rect (not pill) dialog action button. Use in pairs inside a
/// single Row passed as the sole `actions` entry of an AlertDialog, each
/// wrapped in Expanded, so both buttons stretch edge-to-edge within the
/// dialog's padding instead of the default compact end-aligned actions.
class AppDialogButton extends StatelessWidget {
  const AppDialogButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return primary
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : OutlinedButton(onPressed: onPressed, child: Text(label));
  }
}

/// Row of [AppDialogButton]s spanning the dialog width, for use as the
/// single entry in `AlertDialog.actions`.
class AppDialogButtonRow extends StatelessWidget {
  const AppDialogButtonRow({super.key, required this.buttons});

  final List<AppDialogButton> buttons;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < buttons.length; i++) {
      if (i > 0) children.add(const SizedBox(width: 10));
      children.add(Expanded(child: buttons[i]));
    }
    return Row(children: children);
  }
}
