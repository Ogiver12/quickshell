import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

import "../Services"
import "../config.js" as Config

Item {
  id: bt

  Text {
    text: BluetoothService.bluetoothEnabled
    color: Config.col.fg
  }
}
