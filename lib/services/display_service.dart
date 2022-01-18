import 'package:dbus/dbus.dart';

const displaysInterface = 'org.gnome.Mutter.DisplayConfig';

const displayPath = '/org/gnome/Mutter/DisplayConfig';

/// TODO: implement the following methods and signals of org.gnome.Mutter.DisplayConfig
///
/// Methods:
///
/// ApplyConfiguration (UInt32 serial, Boolean persistent, Array of [Struct of (UInt32, Int32, Int32, Int32, UInt32, Array of [UInt32], Dict of {String, Variant})] crtcs, Array of [Struct of (UInt32, Dict of {String, Variant})] outputs) ↦ ()
/// ApplyMonitorsConfig (UInt32 serial, UInt32 method, Array of [Struct of (Int32, Int32, Double, UInt32, Boolean, Array of [Struct of (String, String, Dict of {String, Variant})])] logical_monitors, Dict of {String, Variant} properties) ↦ ()
/// ChangeBacklight (UInt32 serial, UInt32 output, Int32 value) ↦ (Int32 new_value)
/// GetCrtcGamma (UInt32 serial, UInt32 crtc) ↦ (Array of [UInt16] red, Array of [UInt16] green, Array of [UInt16] blue)
/// GetCurrentState () ↦ (UInt32 serial, Array of [Struct of (Struct of (String, String, String, String), Array of [Struct of (String, Int32, Int32, Double, Double, Array of [Double], Dict of {String, Variant})], Dict of {String, Variant})] monitors, Array of [Struct of (Int32, Int32, Double, UInt32, Boolean, Array of [Struct of (String, String, String, String)], Dict of {String, Variant})] logical_monitors, Dict of {String, Variant} properties)
/// GetResources () ↦ (UInt32 serial, Array of [Struct of (UInt32, Int64, Int32, Int32, Int32, Int32, Int32, UInt32, Array of [UInt32], Dict of {String, Variant})] crtcs, Array of [Struct of (UInt32, Int64, Int32, Array of [UInt32], String, Array of [UInt32], Array of [UInt32], Dict of {String, Variant})] outputs, Array of [Struct of (UInt32, Int64, UInt32, UInt32, Double, UInt32)] modes, Int32 max_screen_width, Int32 max_screen_height)
/// SetCrtcGamma (UInt32 serial, UInt32 crtc, Array of [UInt16] red, Array of [UInt16] green, Array of [UInt16] blue) ↦ ()
/// SetOutputCTM (UInt32 serial, UInt32 output, Struct of (UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64, UInt64) ctm) ↦ ()
///
/// Signals:
///
/// MonitorsChanged

class DisplayService {
  DisplayService() : _object = _createObject();

  final DBusRemoteObject _object;
  // bool? _displayChanged;
  DBusArray? _currentState;

  Future<void> init() async {
    await _initProperties();
  }

  static DBusRemoteObject _createObject() {
    return DBusRemoteObject(
      DBusClient.session(),
      name: displaysInterface,
      path: DBusObjectPath(displayPath),
    );
  }

  Future<void> _initProperties() async {
    _currentState = await _object.getCurrentState();
  }

  // void _updateProperties(DBusPropertiesChangedSignal signal) {}
}

extension _DisplayObject on DBusRemoteObject {
  Future<DBusArray?> getCurrentState() async {
    final value = await getProperty(displaysInterface, 'GetCurrentState');
    return (value as DBusArray);
  }
}

extension _MonitorsChangedSignal on DBusPropertiesChangedSignal {
  bool? getMonitorsChanged() {
    final property = changedProperties['MonitorsChanged'] as DBusBoolean?;
    return property?.value;
  }
}

class DisplayConfig {
  // UInt32 serial
  DBusInt32? serial;

  // Array of [Struct of (Struct of (String, String, String, String),Array of [Struct of (String, Int32, Int32, Double, Double, Array of [Double], Dict of {String, Variant})], Dict of {String, Variant})] monitors,
  DBusArray? monitors;

  // Array of [Struct of (Int32, Int32, Double, UInt32, Boolean, Array of [Struct of (String, String, String, String)], Dict of {String, Variant})] logical_monitors,
  // a                   (i      i      d       u       b        a                   (s       s       ?       ?     )   a       {s       v      })
  DBusArray? logicalMonitors; // DBusSignature('a(iiduba(ssa{sv}))')

  // Dict of {String, Variant} properties
  DBusDict? properties; // a{sv} <DBusString, DBusVariant>

  DisplayConfig(
      {this.serial, this.monitors, this.logicalMonitors, this.properties});

// Example output of GetCurrentState:
// 3, <---- easy to say that this is the serial
// [(('DP-1', 'LEN', 'Q24h-10', 'U5HCDCKD'),
//   [('2560x1440@74.970924377441406',
//     2560,
//     1440,
//     74.9709243774414,
//     1.0,
//     [1.0, 2.0, 3.0, 4.0],
//     {}),
//    ('2560x1440@59.950550079345703',
//     2560,
//     1440,
//     59.9505500793457,
//     1.0,
//     [1.0, 2.0, 3.0, 4.0],
//     {'is-current': True, 'is-preferred': True}),
//    ('1920x1200@59.884601593017578',
//     1920,
//     1200,
//     59.88460159301758,
//     1.0,
//     [1.0, 2.0, 3.0],
//     {}),
//    ('1920x1080@74.972503662109375',
//     1920,
//     1080,
//     74.97250366210938,
//     1.0,
//     [1.0, 2.0, 3.0],
//     {}),
//    ('1920x1080@60', 1920, 1080, 60.0, 1.0, [1.0, 2.0, 3.0], {}),
//    ('1920x1080@59.940200805664062',
//     1920,
//     1080,
//     59.94020080566406,
//     1.0,
//     [1.0, 2.0, 3.0],
//     {}),
//    ('1920x1080@50', 1920, 1080, 50.0, 1.0, [1.0, 2.0, 3.0], {}),
//    ('1680x1050@59.883251190185547',
//     1680,
//     1050,
//     59.88325119018555,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1440x900@59.887443542480469',
//     1440,
//     900,
//     59.88744354248047,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1366x768@59.789539337158203',
//     1366,
//     768,
//     59.7895393371582,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x1024@75.024673461914062',
//     1280,
//     1024,
//     75.02467346191406,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x1024@60.019741058349609',
//     1280,
//     1024,
//     60.01974105834961,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x720@60', 1280, 720, 60.0, 1.0, [1.0, 2.0], {}),
//    ('1280x720@59.940200805664062',
//     1280,
//     720,
//     59.94020080566406,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x720@50', 1280, 720, 50.0, 1.0, [1.0, 2.0], {}),
//    ('1024x768@75.028579711914062',
//     1024,
//     768,
//     75.02857971191406,
//     1.0,
//     [1.0],
//     {}),
//    ('1024x768@70.069358825683594', 1024, 768, 70.0693588256836, 1.0, [1.0], {}),
//    ('1024x768@60.003841400146484',
//     1024,
//     768,
//     60.003841400146484,
//     1.0,
//     [1.0],
//     {}),
//    ('832x624@74.55126953125', 832, 624, 74.55126953125, 1.0, [1.0], {}),
//    ('800x600@75', 800, 600, 75.0, 1.0, [1.0], {}),
//    ('800x600@72.187568664550781', 800, 600, 72.18756866455078, 1.0, [1.0], {}),
//    ('800x600@60.316539764404297', 800, 600, 60.3165397644043, 1.0, [1.0], {}),
//    ('800x600@56.25', 800, 600, 56.25, 1.0, [1.0], {}),
//    ('720x576@50', 720, 576, 50.0, 1.0, [1.0], {})],
//   {'display-name': 'Lenovo Group Limited 24"', 'is-builtin': False}),
//  (('eDP-1', 'LGD', '0x0608', '0x00000000'),
//   [('1920x1080@60.020423889160156',
//     1920,
//     1080,
//     60.020423889160156,
//     1.0,
//     [1.0, 2.0, 3.0],
//     {'is-preferred': True}),
//    ('1920x1080@59.962844848632812',
//     1920,
//     1080,
//     59.96284484863281,
//     1.0,
//     [1.0, 2.0, 3.0],
//     {}),
//    ('1920x1080@47.999031066894531',
//     1920,
//     1080,
//     47.99903106689453,
//     1.0,
//     [1.0, 2.0, 3.0],
//     {}),
//    ('1680x1050@59.954250335693359',
//     1680,
//     1050,
//     59.95425033569336,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1600x900@59.946022033691406',
//     1600,
//     900,
//     59.946022033691406,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1440x1080@59.988838195800781',
//     1440,
//     1080,
//     59.98883819580078,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1440x900@59.887443542480469',
//     1440,
//     900,
//     59.88744354248047,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1400x1050@59.978443145751953',
//     1400,
//     1050,
//     59.97844314575195,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1368x768@59.882049560546875',
//     1368,
//     768,
//     59.882049560546875,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x960@59.939048767089844',
//     1280,
//     960,
//     59.939048767089844,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x800@59.810325622558594',
//     1280,
//     800,
//     59.810325622558594,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1280x720@59.855125427246094',
//     1280,
//     720,
//     59.855125427246094,
//     1.0,
//     [1.0, 2.0],
//     {}),
//    ('1152x864@59.958633422851562',
//     1152,
//     864,
//     59.95863342285156,
//     1.0,
//     [1.0],
//     {}),
//    ('1024x768@59.920131683349609',
//     1024,
//     768,
//     59.92013168334961,
//     1.0,
//     [1.0],
//     {}),
//    ('800x600@59.861404418945312', 800, 600, 59.86140441894531, 1.0, [1.0], {})],
//   {'display-name': 'Eingebaute Anzeige', 'is-builtin': True})],
// [(0, 0, 1.0, 0, True, [('DP-1', 'LEN', 'Q24h-10', 'U5HCDCKD')], {})], <--- logical monitors ? a(iiduba(ssa{sv}))
// {'layout-mode': 2, 'legacy-ui-scaling-factor': 1, 'renderer': 'native'} <--- easy to say that these are the properties
}
