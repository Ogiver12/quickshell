import Quickshell
import QtQuick
import QtQuick.Layouts

import "../config.js" as Config
import "."

/*
Text {
  id: root

  property string value: "--"
  property string unit: ""

  text: value + unit

  color: Config.col.fg
  font.pixelSize: Config.bar.fontSize + 20
  font.family: Config.bar.fontFamily
  font.weight: 500
  Layout.rightMargin: 8

  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
}
*/

GridLayout {
  id: statsGrid

  property int currentView: 0
  property bool open: statsGrid.currentView === 1

  anchors.top: parent.top
  anchors.topMargin: 20
  anchors.horizontalCenter: parent.horizontalCenter

  columns: 2
  columnSpacing: 20
  rowSpacing: 20

  opacity: 0
  visible: opacity > 0

  states: State {
    name: "open"
    when: statsGrid.open
    PropertyChanges { target: statsGrid; opacity: 1 }
  }

  transitions: Transition {
    from: ""; to: "open"
    SequentialAnimation {
      PauseAnimation { duration: 20 }
      NumberAnimation {
	property: "opacity"
	duration: 250
	easing.type: Easing.OutCubic
      }
    }
  }

  Rectangle {
    width: 170; height: 130; color: Config.col.bg2; radius: 16
    Text {
      text: "CPU"
      leftPadding: 10
      topPadding: 10
      font.pixelSize: Config.bar.fontSize + 8
      font.family: Config.bar.fontFamily
      font.weight: 500
      color: Config.col.cyan
    }
    Text {
      text: SystemStats.cpuUsage + "%"
      color: Config.col.fg
      font.pixelSize: Config.bar.fontSize + 20
      font.family: Config.bar.fontFamily
      font.weight: 500
      Layout.rightMargin: 8

      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      anchors.fill: parent
    }
  }

  Rectangle {
    width: 170; height: 130; color: Config.col.bg2; radius: 16
    Text {
      text: "CPU Temp"
      leftPadding: 10
      topPadding: 10
      font.pixelSize: Config.bar.fontSize + 8
      font.family: Config.bar.fontFamily
      font.weight: 500
      color: Config.col.purple
    }
    Text {
      text: SystemStats.cpuTemp + "°C"
      color: Config.col.fg
      font.pixelSize: Config.bar.fontSize + 20
      font.family: Config.bar.fontFamily
      font.weight: 500
      Layout.rightMargin: 8

      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      anchors.fill: parent
    }
  }

  Rectangle {
    width: 170; height: 130; color: Config.col.bg2; radius: 16
    Text {
      text: "RAM"
      leftPadding: 10
      topPadding: 10
      font.pixelSize: Config.bar.fontSize + 8
      font.family: Config.bar.fontFamily
      font.weight: 500
      color: Config.col.yellow
    }
    Text {
      text: SystemStats.memUsage + "%"
      color: Config.col.fg
      font.pixelSize: Config.bar.fontSize + 20
      font.family: Config.bar.fontFamily
      font.weight: 500
      Layout.rightMargin: 8

      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      anchors.fill: parent
    }
  }

  Rectangle {
    width: 170; height: 130; color: Config.col.bg2; radius: 16
    Text {
      text: "Disk"
      leftPadding: 10
      topPadding: 10
      font.pixelSize: Config.bar.fontSize + 8
      font.family: Config.bar.fontFamily
      font.weight: 500
      color: Config.col.blue
    }
    Text {
      text: SystemStats.diskUsage + "%"
      color: Config.col.fg
      font.pixelSize: Config.bar.fontSize + 20
      font.family: Config.bar.fontFamily
      font.weight: 500
      Layout.rightMargin: 8

      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      anchors.fill: parent
    }
  }
}
