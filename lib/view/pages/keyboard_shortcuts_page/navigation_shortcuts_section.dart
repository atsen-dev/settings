import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gsettings/gsettings.dart';
import 'package:settings/view/pages/keyboard_shortcuts_page/keyboard_shortcut_row.dart';
import 'package:settings/view/widgets/settings_section.dart';

class NavigationShortcutsSection extends StatefulWidget {
  const NavigationShortcutsSection({Key? key}) : super(key: key);

  @override
  _NavigationShortcutsSectionState createState() =>
      _NavigationShortcutsSectionState();
}

class _NavigationShortcutsSectionState
    extends State<NavigationShortcutsSection> {
  late GSettings _settingsWmShortcuts;

  @override
  void initState() {
    _settingsWmShortcuts =
        GSettings(schemaId: 'org.gnome.desktop.wm.keybindings');
    super.initState();
  }

  @override
  void dispose() {
    _settingsWmShortcuts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(headline: 'Navigation Shortcuts', children: [
      KeyboardShortcutRow(
          schemaId: _settingsWmShortcuts.schemaId,
          settingsKey: 'switch-windows')
    ]);
  }
}
