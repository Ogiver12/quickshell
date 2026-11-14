import QtQuick
import "../config.js" as Config

Text {
  text: Time.time
  color: Config.col.fg
  font.pixelSize: Config.bar.fontSize + 2
  font.family: Config.bar.fontFamily
  font.weight: 500
}
