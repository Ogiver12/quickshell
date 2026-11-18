import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "Components"
import "config.js" as Config

Scope {
  id: root

  // 0 = default (clock + workspace)
  // 1 = system stats
  // 2 = bluetooth menu
  // 3 = media menu
  // 99 = vol popup
  property int currentView: 0

  IpcHandler {
    target: "root"
    function setView(view: int): void { root.currentView = view; }
  }

  function getWidth() {
    switch (currentView) {
      case 0: return 100
      case 1: return 400
      case 2: return 400
      case 3: return 600
      case 99: return 240
      default: return 100
    }
  }

  function getHeight() {
    switch (currentView) {
      case 0: return 34
      case 1: return 320
      case 2: return 400
      case 3: return 180
      case 99: return 34
      default: return 34
    }
  }

  function getRadius() {
    switch (currentView) {
      case 0: return getHeight() / 2
      case 1: return 16
      case 2: return 16
      case 3: return 16
      default: return getHeight() / 2
    }
  }

  PanelWindow {
    anchors {
      top: true
    }

    // area to which the bar can expand to
    implicitHeight: 600
    implicitWidth: 1000

    color: "transparent"

    exclusiveZone: 44 // reserved space for the island
    mask: Region { item: island } // clicks can go past this panel window but not the pill

    Rectangle {
      id: island
      anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 5 }
      height: getHeight()
      width: getWidth()
      radius: getRadius()

      color: Config.col.bg

      clip: true

      Behavior on width {
	//NumberAnimation { duration: 300; easing.type: Easing.OutBack }
	SpringAnimation { spring: 5; damping: 0.38; mass: 0.85; epsilon: 0.005 }
      }
      Behavior on height {
	//NumberAnimation { duration: 300; easing.type: Easing.OutBack }
	SpringAnimation { spring: 5; damping: 0.38; mass: 0.85; epsilon: 0.005 }
      }

      RowLayout{
	anchors.fill: parent
	ClockWidget {
	  visible: root.currentView === 0
	  Layout.alignment: Qt.AlignHCenter
	}
      }
      SystemStatsWidget {
	currentView: root.currentView
      }
      BluetoothMenu {
	visible: root.currentView === 2
      }
      MediaWidget {
	visible: root.currentView === 3
      }
      Audio {
	id: audioPopup

	onOpenChanged: {
	  if (open)
	    root.currentView = 99
	  else if (root.currentView === 99)
	    root.currentView = 0
	}
      }
    }
  }
}
