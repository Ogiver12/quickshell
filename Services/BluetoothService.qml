pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Bluetooth
import QtQuick

// based on bnsplit's bluetooth service

Singleton {
  id: root

  readonly property var adapter: Bluetooth.defaultAdapter

  readonly property bool bluetoothEnabled: adapter?.enabled ?? false
  readonly property var devices: {
    if (!Bluetooth.devices)
      return [];

    return [...Bluetooth.devices.values].sort((a, b) =>
      Number(b.connected - a.connected) ||
      Number((getState(b.state) === "Connecting") -
      Number(getState(a.state) === "Connecting")) ||
      Number(b.paired - a.paired)
    );
  }
  property BluetoothDevice defaultDevice: Bluetooth?.devices?.values?.find(d => d.connected) ?? null
  property bool bluetoothConnected: defaultDevice !== null
  property string bluetoothDeviceName: defaultDevice?.name ?? ""
  property int bluetoothDeviceBattery: defaultDevice?.batteryAvailable ? Math.round(defaultDevice.battery * 100) : 0
  property string bluetoothDeviceIcon: defaultDevice?.icon ? defaultDevice.icon + "-symbolic" : ""

  function getMaterialSymbol(iconName) {
    if (!iconName)
    return "bluetooth";
    const icon = iconName.replace("-symbolic", "");
    const deviceIconMap = {
      "audio-headphones": "headphones",
      "audio-headset": "headset_mic",
      "input-keyboard": "keyboard",
      "input-mouse": "mouse",
      "input-gaming": "sports_esports",
      "phone": "smartphone",
      "computer": "desktop_windows",
      "audio-speakers": "speaker",
      "audio-card": "speaker"
    };
    return deviceIconMap[icon] || "bluetooth";
  }

  property string materialSymbol: {
    if (!root.bluetoothEnabled)
    return "bluetooth_disabled";

    if (root.bluetoothConnected) {
      const icon = root.getMaterialSymbol(root.bluetoothDeviceIcon);
      return icon === "bluetooth" ? "bluetooth_connected" : icon;
    }

    return "bluetooth";
  }

  property string symbolicIcon: {
    if (!root.bluetoothEnabled)
    return "bluetooth-disabled-symbolic";

    if (root.bluetoothDeviceIcon !== "")
    return root.bluetoothDeviceIcon;

    if (root.bluetoothConnected)
    return "bluetooth-paired-symbolic";
    else if (root.bluetoothEnabled)
    return "bluetooth-active-symbolic";

    return "bluetooth-symbolic";
  }

  /*
  function toggleBluetooth() {
    if (Bluetooth.defaultAdapter?.state !== BluetoothAdapterState.Blocked) {
      Quickshell.execDetached(["sh", "-c", "rfkill block bluetooth"]);
    } else {
      Quickshell.execDetached(["sh", "-c", "rfkill unblock bluetooth"]);
    }
  }
  */

  function toggleBluetooth()  {
    const adapter = Bluetooth.defaultAdapter;

    if (adapter)
      adapter.enabled = !adapter.enabled;
  }

  function getState(state) {
    return BluetoothDeviceState.toString(state);
  }
}
