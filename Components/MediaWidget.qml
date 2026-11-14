import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import "../config.js" as Config

Item {
  id: root

  //property var player: Mpris.players.values[0] ?? null

  property var player: {
    const list = Mpris.players.values;
    if (!list || list.length === 0) return null;
    for (let i = 0; i < list.length; i++) {
      if (list[i] && list[i].isPlaying) return list[i];
    }
    return list[0] ?? null;
  }

  property bool isPlaying: player !== null && player.isPlaying

  readonly property real safePosition: {
    if (root.player === null) return 0;
    const p = root.player.position;
    return (isFinite(p) && p > 0) ? p : 0;
  }

  readonly property real safeLength: {
    if (root.player === null) return 0;
    const l = root.player.length;
    return (isFinite(l) && l > 0) ? l : 0;
  }

  readonly property real progress:
    safeLength > 0 ? Math.max(0, Math.min(1, safePosition / safeLength)) : 0

  // update player position
  FrameAnimation {
    // only emit the signal when the position is actually changing.
    running: root.player !== null && player.playbackState == MprisPlaybackState.Playing
    // emit the positionChanged signal every frame.
    onTriggered: {
      if (root.player !== null) root.player.positionChanged();
    }
  }

  Text {
    text: root.player ? root.player.trackTitle : "Nothing Playing"
    anchors{
      top: parent.top
      left: parent.left
      topMargin: 15
      leftMargin: 15 + albumArt.width + 15
    }
    elide: Text.ElideRight
    width: 400
    font.pixelSize: Config.bar.fontSize + 14
    font.family: Config.bar.fontFamily
    font.weight: 500
    color: Config.col.fg
  }

  Text {
    text: root.player ? root.player.trackArtist : ""
    anchors{
      top: parent.top
      left: parent.left
      topMargin: 50
      leftMargin: 15 + albumArt.width + 15
    }
    elide: Text.ElideRight
    width: 400
    font.pixelSize: Config.bar.fontSize + 4
    font.family: Config.bar.fontFamily
    font.weight: 500
    color: Config.col.blue
  }

  Image {
    id: albumArt
    property bool rounded: true
    property bool adapt: true

    anchors{
      top: parent.top
      left: parent.left
      topMargin: 15
      leftMargin: 15
    }

    source: root.player ? root.player.trackArtUrl : "../Assets/Cat.png"
    fillMode: Image.PreserveAspectCrop
    width: 150; height: 150;
    cache: false

    layer.enabled: rounded
    layer.effect: OpacityMask {
      maskSource: Item {
	width: albumArt.width
	height: albumArt.height
	Rectangle {
	  anchors.centerIn: parent
	  width: albumArt.adapt ? albumArt.width : Math.min(albumArt.width, albumArt.height)
	  height: albumArt.adapt ? albumArt.height : width
	  radius: 16
	}
      }
    }
  }

  Rectangle {
    id: progressBar
    width: 400
    height: 5
    anchors {
      top: parent.top
      left: parent.left
      topMargin: albumArt.height + 2
      leftMargin: 15 + albumArt.width + 17
    }
    radius: height / 2
    color: Config.col.bg2
    Rectangle {
      id: progressBarIndicatior
      anchors{ left: parent.left; top: parent.top; bottom: parent.bottom }

      property real positionPercent: root.progress
      width: positionPercent * 400
      color: Config.col.fg
      radius: height / 2
    }
  }
  Text {
    property int totalSeconds: Math.floor(root.safeLength)
    property int minutes: Math.floor(root.safeLength / 60)
    property int seconds: totalSeconds % 60

    anchors {
      top: parent.top
      left: parent.left
      topMargin: albumArt.height - 31
      leftMargin: 537
      
    }

    text: minutes + ":" + String(seconds).padStart(2, "0")
    font.pixelSize: Config.bar.fontSize + 4
    font.family: Config.bar.fontFamily
    font.weight: 500
    color: Config.col.fg2
  }

  Text {
    property int totalSeconds: Math.floor(root.safePosition)
    property int minutes: Math.floor(root.safePosition / 60)
    property int seconds: totalSeconds % 60

    anchors {
      top: parent.top
      left: parent.left
      topMargin: albumArt.height - 31
      leftMargin: 15 + albumArt.width + 17
    }

    text: minutes + ":" + String(seconds).padStart(2, "0")
    font.pixelSize: Config.bar.fontSize + 4
    font.family: Config.bar.fontFamily
    font.weight: 500
    color: Config.col.fg2
  }
}
