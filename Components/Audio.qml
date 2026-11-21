import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import "../config.js" as Config

Item {
  id: root
  anchors.fill: parent

  property var sink: Pipewire.defaultAudioSink
  readonly property int volumeLevel: sink && sink.ready && sink.audio ? Math.round(sink.audio.volume * 100) : 0
  readonly property bool muted: sink && sink.audio ? sink.audio.muted : false

  property bool open: false

  PwObjectTracker {
    objects: [root.sink]
  }

  visible: open

  onVolumeLevelChanged: {
    timeOutTimer.restart()
    root.open = true
  }

  Timer {
    id: timeOutTimer
    interval: 1200
    repeat: false

    onTriggered: {
      root.open = 0
    }
  }

  Item {
    anchors{
      left: parent.left
      top: parent.top
    }
    width: 50
    height: 34
    Image {
      source: root.muted ? "../Assets/volume_off.svg"
	    : root.volumeLevel >= 50 ? "../Assets/volume_up.svg"
	    : root.volumeLevel >= 1 && root.volumeLevel <= 49 ? "../Assets/volume_down.svg"
	    : root.volumeLevel === 0 ? "../Assets/volume_mute.svg"
	    : "../Assets/volume_off.svg"
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter
    }
  }

  Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    width: 140
    height: 4
    radius: height / 2
    color: Config.col.bg2
    Rectangle {
      anchors {
	left: parent.left
	top: parent.top
	bottom: parent.bottom
      }
      height: 4
      width: root.volumeLevel > 0 ? root.volumeLevel / 100 * 140 : 0
      radius: height / 2
      color: Config.col.fg
    }
  }

  Text {
    text: root.volumeLevel + "%"
    font.family: Config.bar.fontFamily
    font.pixelSize: Config.bar.fontSize - 1
    font.weight: 600
    color: Config.col.fg
    anchors {
      right: parent.right
      verticalCenter: parent.verticalCenter
      rightMargin: 10
    }
  }
}
