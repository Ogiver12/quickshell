import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

Scope {
  id: bluetoothMenu

  Text {
    text: Bluetooth.defaultAdapter?.discovering ?? false
  }
}
