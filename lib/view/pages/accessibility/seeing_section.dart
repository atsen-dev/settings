import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:settings/view/pages/accessibility/accessibility_model.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'package:yaru_icons/yaru_icons.dart';

class SeeingSection extends StatelessWidget {
  const SeeingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return YaruSection(
      headline: 'Seeing',
      children: [
        YaruSwitchRow(
          mainWidget: const Text('High Contrast'),
          value: model.highContrast,
          onChanged: (value) => model.setHighContrast(value),
        ),
        YaruSwitchRow(
          mainWidget: const Text('Large Text'),
          value: model.largeText,
          onChanged: (value) => model.setLargeText(value),
        ),
        const _CursorSize(),
        YaruExtraOptionRow(
          iconData: YaruIcons.settings,
          actionLabel: 'Zoom',
          value: model.zoom,
          onChanged: (value) => model.setZoom(value),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ChangeNotifierProvider.value(
              value: model,
              child: const _ZoomSettings(),
            ),
          ),
        ),
        YaruSwitchRow(
          mainWidget: const Text('Screen Reader'),
          actionDescription:
              'The screen reader reads displayed text as you move the focus',
          value: model.screenReader,
          onChanged: (value) => model.setScreenReader(value),
        ),
        YaruSwitchRow(
          mainWidget: const Text('Sound Keys'),
          actionDescription:
              'Beep when Num Lock or Caps Lock are turned on or off',
          value: model.toggleKeys,
          onChanged: (value) => model.setToggleKeys(value),
        ),
      ],
    );
  }
}

class _CursorSize extends StatelessWidget {
  const _CursorSize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return YaruRow(
      enabled: model.cursorSize != null,
      mainWidget: const Text('Cursor Size'),
      description: 'Cursor size can be combined with zoom '
          'to make it easier to see the cursor',
      actionWidget: Row(
        children: [
          const SizedBox(width: 24.0),
          Text(model.cursorSizeString()),
          const SizedBox(width: 24.0),
          SizedBox(
            width: 40,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => ChangeNotifierProvider.value(
                  value: model,
                  child: const _CursorSizeSettings(),
                ),
              ),
              child: const Icon(YaruIcons.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorSizeSettings extends StatelessWidget {
  const _CursorSizeSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return YaruSimpleDialog(
      title: 'Cursor Size',
      closeIconData: YaruIcons.window_close,
      children: [
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_24px.png',
          onPressed: () => model.setCursorSize(24),
          selected: model.cursorSize == 24,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_32px.png',
          onPressed: () => model.setCursorSize(32),
          selected: model.cursorSize == 32,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_48px.png',
          onPressed: () => model.setCursorSize(48),
          selected: model.cursorSize == 48,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_64px.png',
          onPressed: () => model.setCursorSize(64),
          selected: model.cursorSize == 64,
        ),
        _CursorButton(
          imageName: 'assets/images/cursor/left_ptr_96px.png',
          onPressed: () => model.setCursorSize(96),
          selected: model.cursorSize == 96,
        ),
      ],
    );
  }
}

class _CursorButton extends StatelessWidget {
  const _CursorButton({
    Key? key,
    required this.imageName,
    required this.onPressed,
    required this.selected,
  }) : super(key: key);

  final String imageName;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: 100,
          height: 100,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.onSurface.withAlpha(
                        selected ? 60 : 0,
                      ),
            ),
            onPressed: onPressed,
            child: Image.asset(imageName),
          ),
        ),
      ),
    );
  }
}

class _ZoomSettings extends StatelessWidget {
  const _ZoomSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);

    return YaruSimpleDialog(
      title: 'Zoom Options',
      closeIconData: YaruIcons.window_close,
      children: [
        Text(
          'Magnifier',
          style: Theme.of(context).textTheme.headline6,
        ),
        YaruRow(
          enabled: model.magFactor != null,
          mainWidget: const Text('Magnification'),
          actionWidget: SizedBox(
            height: 40,
            width: 150,
            child: SpinBox(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              enabled: true,
              min: 1,
              max: 20,
              step: 0.25,
              decimals: 2,
              value: model.magFactor ?? 2,
              onChanged: (value) => model.setMagFactor(value),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Magnifier Position'),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: _MagnifierPositionOptions(),
        ),
        Text(
          'Crosshairs',
          style: Theme.of(context).textTheme.headline6,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: YaruCheckboxRow(
            enabled: model.crossHairs != null,
            value: model.crossHairs ?? false,
            onChanged: (value) => model.setCrossHairs(value!),
            text: 'Visible',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: YaruCheckboxRow(
            enabled: model.crossHairsClip != null,
            value: model.crossHairsClip ?? false,
            onChanged: (value) => model.setCrossHairsClip(value!),
            text: 'Overlaps mouse cursor',
          ),
        ),
        YaruSliderRow(
          actionLabel: 'Thickness',
          enabled: true,
          showValue: false,
          min: 1,
          max: 100,
          defaultValue: 8,
          value: model.crossHairsThickness,
          onChanged: (value) => model.setCrossHairsThickness(value),
        ),
        YaruSliderRow(
          actionLabel: 'Length',
          enabled: true,
          showValue: false,
          min: 20,
          max: 4096,
          defaultValue: 4096,
          value: model.crossHairsLength,
          onChanged: (value) => model.setCrossHairsLength(value),
        ),
        const YaruRow(
            mainWidget: Text('Color'),
            actionWidget: OutlinedButton(
              onPressed: null,
              child: Text('Color'),
            ),
            enabled: false),
        Text(
          'Color Effects',
          style: Theme.of(context).textTheme.headline6,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: YaruCheckboxRow(
            enabled: model.inverseLightness != null,
            value: model.inverseLightness ?? false,
            onChanged: (value) => model.setInverseLightness(value!),
            text: 'White on black',
          ),
        ),
        YaruSliderRow(
          actionLabel: 'Brightness',
          enabled: true,
          showValue: false,
          min: -0.75,
          max: 0.75,
          defaultValue: 0,
          value: model.colorBrightness,
          onChanged: (value) => model.setColorBrightness(value),
        ),
        YaruSliderRow(
          actionLabel: 'Contrast',
          enabled: true,
          showValue: false,
          min: -0.75,
          max: 0.75,
          defaultValue: 0,
          value: model.colorContrast,
          onChanged: (value) => model.setColorContrast(value),
        ),
        YaruSliderRow(
          actionLabel: 'Saturation',
          enabled: true,
          showValue: false,
          min: 0,
          max: 1,
          defaultValue: 1,
          value: model.colorSaturation,
          onChanged: (value) => model.setColorSaturation(value),
        ),
      ],
    );
  }
}

class _MagnifierPositionOptions extends StatelessWidget {
  const _MagnifierPositionOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AccessibilityModel>(context);
    return Column(
      children: [
        _RadioRow(
          title: 'Follow mouse cursor',
          value: true,
          enabled: true,
          groupValue: model.lensMode,
          onChanged: (bool? value) => model.setLensMode(value!),
        ),
        _RadioRow(
          title: 'Screen part',
          enabled: true,
          value: false,
          groupValue: model.lensMode,
          onChanged: (bool? value) => model.setLensMode(value!),
          secondary: DropdownButton<String>(
            onChanged: !model.screenPartEnabled
                ? null
                : (value) => model.setScreenPosition(value!),
            value: model.screenPosition,
            items: [
              for (var item in AccessibilityModel.screenPositions)
                DropdownMenuItem(
                    child: Text(item.toLowerCase().replaceAll('-', ' ')),
                    value: item)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              YaruCheckboxRow(
                enabled: model.screenPartEnabled && model.scrollAtEdges != null,
                value: model.scrollAtEdges ?? false,
                onChanged: (value) => model.setScrollAtEdges(value!),
                text: 'Magnifier extends outside of screen',
              ),
              _RadioRow(
                title: 'Keep magnifier cursor centered',
                value: 'centered',
                groupValue: model.mouseTracking,
                onChanged: (String? value) => model.setMouseTracking(value!),
                enabled: model.screenPartEnabled,
              ),
              _RadioRow(
                title: 'Magnifier cursor pushes contents around',
                value: 'push',
                groupValue: model.mouseTracking,
                onChanged: (String? value) => model.setMouseTracking(value!),
                enabled: model.screenPartEnabled,
              ),
              _RadioRow(
                title: 'Magnifier cursor moves with contents',
                value: 'proportional',
                groupValue: model.mouseTracking,
                onChanged: (String? value) => model.setMouseTracking(value!),
                enabled: model.screenPartEnabled,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    Key? key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.enabled,
    this.secondary,
  }) : super(key: key);

  final String title;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled && value != null;

    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: enabled ? onChanged : null,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            title,
            style: enabled
                ? null
                : TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
        if (secondary != null) secondary!,
      ],
    );
  }
}
