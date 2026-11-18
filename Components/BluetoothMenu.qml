import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Services"
import "../config.js" as Config

Item {
  id: root

  anchors.fill: parent

  // Bluetooth header at top
  Item {
    anchors.fill: parent

    Text {
      text: "Bluetooth"
      font.pixelSize: Config.bar.fontSize + 8
      font.family: Config.bar.fontFamily
      font.weight: 600
      color: Config.col.fg

      anchors {
	top: parent.top
	left: parent.left
	topMargin: 20
	leftMargin: 20
      }
    }

    Switch {
      id: btToggle
      checked: BluetoothService.bluetoothEnabled
      onToggled: {
	if (BluetoothService.adapter)
	  BluetoothService.adapter.enabled = checked
      }

      indicator: Rectangle {
	implicitWidth: 40
	implicitHeight: 20
	x: btToggle.leftPadding
	y: parent.height / 2 - height / 2
	radius: implicitHeight / 2
	color: btToggle.checked ? Config.col.blue : Config.col.bg2

	Rectangle {
	  x: btToggle.checked ? parent.width - (parent.height / 2 - height / 2) - width : parent.height / 2 - height / 2
	  y: parent.height / 2 - height / 2
	  width: 16
	  height: 16
	  radius: height / 2
	  color: btToggle.down ? Config.col.bg2 : Config.col.bg

	  Behavior on x {
	    NumberAnimation { duration: 80 }
	  }
	}
      }

      anchors {
	top: parent.top
	right: parent.right
	topMargin: 20
	rightMargin: 20
      }
    }
  }
}
