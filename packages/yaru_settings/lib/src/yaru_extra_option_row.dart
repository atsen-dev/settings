import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class YaruExtraOptionRow extends StatelessWidget {
  /// Creates a row having switch, label, description and YaruOptionButton.
  const YaruExtraOptionRow({
    super.key,
    this.enabled = true,
    required this.actionLabel,
    this.actionDescription,
    required this.value,
    required this.onChanged,
    required this.onPressed,
    required this.iconData,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// Whether or not we can interact with the widget
  final bool enabled;

  /// Specifies the label for the row.
  final String actionLabel;

  /// Specifies description for the row.
  final String? actionDescription;

  /// Current value of [Switch] in the row.
  /// The value can be `true` or `false`
  final bool? value;

  /// Called when the user toggles the switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  ///
  ///   bool _extraOptionValue = false;
  ///   YaruExtraOptionRow(
  ///     actionLabel: "Foo Label",
  ///     iconData: YaruIcons.addon,
  ///     onChanged: (c) {
  ///     setState(() {
  ///       _extraOptionValue = c;
  ///       });
  ///     },
  ///     onPressed: () {},
  ///     value: _extraOptionValue,
  ///     actionDescription: "Foo Description",
  ///   ),
  ///
  /// ```
  final Function(bool) onChanged;

  /// Callback that needs to be passed for [YaruOptionButton].
  /// This callback is triggered when the button is clicked.
  final VoidCallback onPressed;

  /// IconData for the [YaruOptionButton].
  final IconData iconData;

  /// The padding [EdgeInsets] which defaults to `EdgeInsets.all(8.0)`.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && value != null;
    return YaruTile(
      enabled: enabled,
      title: Text(actionLabel),
      subtitle: actionDescription != null ? Text(actionDescription!) : null,
      trailing: Row(
        children: [
          Switch(
            value: value ?? false,
            onChanged: enabled ? onChanged : null,
          ),
          const SizedBox(width: 8.0),
          YaruOptionButton(
            onPressed: enabled ? onPressed : null,
            child: Icon(iconData),
          ),
        ],
      ),
    );
  }
}
