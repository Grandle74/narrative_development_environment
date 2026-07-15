import 'package:flutter/material.dart';

/// Wraps an input field with a lock icon when [locked]. Locking is
/// purely a UI/session concept — nothing is persisted. A field becomes
/// "lockable" once it has a value and its AttributeDefinition says
/// `mutable: false` (foundational identity data); tapping the lock
/// shows a confirmation before allowing edits, and it re-locks the next
/// time the screen loads. This is friction against accidental edits,
/// not access control — there's nothing here to secure against another
/// person, only against your own stray tap.
class LockableField extends StatelessWidget {
  const LockableField({
    super.key,
    required this.locked,
    required this.tooltip,
    required this.onUnlock,
    required this.child,
  });

  final bool locked;
  final String tooltip;
  final VoidCallback onUnlock;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!locked) return child;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: child),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.lock_outline),
          tooltip: tooltip,
          onPressed: onUnlock,
        ),
      ],
    );
  }
}
