import 'package:flutter/material.dart';
import 'package:nm/nm.dart';
import 'package:provider/provider.dart';
import 'package:settings/constants.dart';
import 'package:settings/services/bluetooth_service.dart';
import 'package:settings/services/power_settings_service.dart';
import 'package:settings/services/settings_service.dart';
import 'package:settings/view/duration_dropdown_button.dart';
import 'package:settings/view/pages/power/power_settings.dart';
import 'package:settings/view/pages/power/power_settings_dialogs.dart';
import 'package:settings/view/pages/power/power_settings_model.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_settings/yaru_settings.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class PowerSettingsSection extends StatefulWidget {
  const PowerSettingsSection({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<SuspendModel>(
      create: (_) => SuspendModel(
        settings: context.read<SettingsService>(),
        power: context.read<PowerSettingsService>(),
        bluetooth: context.read<BluetoothService>(),
        network: context.read<NetworkManagerClient>(),
      ),
      child: const PowerSettingsSection(),
    );
  }

  @override
  State<PowerSettingsSection> createState() => _PowerSettingsSectionState();
}

class _PowerSettingsSectionState extends State<PowerSettingsSection> {
  @override
  void initState() {
    super.initState();
    context.read<SuspendModel>().init();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SuspendModel>();
    return YaruSection(
      width: kDefaultWidth,
      headline: 'Power Saving',
      children: <Widget>[
        YaruSliderRow(
          enabled:
              model.screenBrightness != null && model.screenBrightness != -1,
          actionLabel: 'Screen Brightness',
          min: model.screenBrightness != -1 ? 0 : -1,
          max: 100,
          value: model.screenBrightness != -1 ? model.screenBrightness : 0,
          onChanged: model.setScreenBrightness,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('Automatic Brightness'),
          value: model.ambientEnabled,
          onChanged: model.setAmbientEnabled,
        ),
        YaruSliderRow(
          enabled: model.keyboardBrightness != null &&
              model.keyboardBrightness != -1,
          actionLabel: 'Keyboard Brightness',
          min: model.keyboardBrightness != -1 ? 0 : -1,
          max: 100,
          value: model.keyboardBrightness != -1 ? model.keyboardBrightness : 0,
          onChanged: model.setKeyboardBrightness,
        ),
        YaruSwitchRow(
          trailingWidget: const Text('Dim Screen When Inactive'),
          value: model.idleDim,
          onChanged: model.setIdleDim,
        ),
        YaruTile(
          enabled: model.idleDelay != null,
          title: const Text('Blank Screen'),
          trailing: DurationDropdownButton(
            value: model.idleDelay,
            values: IdleDelay.values,
            onChanged: model.setIdleDelay,
          ),
        ),
        YaruTile(
          title: const Text('Automatic Suspend'),
          subtitle: Text(model.automaticSuspend.localize(context)),
          trailing: SizedBox(
            width: 40,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: () => showAutomaticSuspendDialog(context),
              child: const Icon(YaruIcons.settings),
            ),
          ),
        ),
        if (model.hasWifi)
          YaruSwitchRow(
            trailingWidget: const Text('Wi-Fi'),
            actionDescription: 'Wi-Fi can be turned off to save power.',
            value: model.wifiEnabled,
            onChanged: model.setWifiEnabled,
          ),
        if (model.hasBluetooth)
          YaruSwitchRow(
            trailingWidget: const Text('Bluetooth'),
            actionDescription: 'Bluetooth can be turned off to save power.',
            value: model.bluetoothEnabled,
            onChanged: model.setBluetoothEnabled,
          ),
      ],
    );
  }
}
