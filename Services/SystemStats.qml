pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string kernelVersion: "Linux"
  property int cpuUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0
  property int memUsage: 0
  property int cpuTemp: 0
  property int diskUsage: 0

  // RAM usage
  Process {
    id: memProc
    command: ["sh", "-c", "free | grep Mem"]
    stdout: SplitParser {
      onRead: data => {
	if (!data) return
	var parts = data.trim().split(/\s+/)
	var total = parseInt(parts[1]) || 1
	var used = parseInt(parts[2]) || 0
	memUsage = Math.round(100 * used / total)
      }
    }
    Component.onCompleted: running = true
  }

  // CPU usage
  Process {
    id: cpuProc
    command: ["sh", "-c", "head -1 /proc/stat"]
    stdout: SplitParser {
      onRead: data => {
	if (!data) return
	var parts = data.trim().split(/\s+/)
	var user = parseInt(parts[1]) || 0
	var nice = parseInt(parts[2]) || 0
	var system = parseInt(parts[3]) || 0
	var idle = parseInt(parts[4]) || 0
	var iowait = parseInt(parts[5]) || 0
	var irq = parseInt(parts[6]) || 0
	var softirq = parseInt(parts[7]) || 0

	var total = user + nice + system + idle + iowait + irq + softirq
	var idleTime = idle + iowait

	if (lastCpuTotal > 0) {
	  var totalDiff = total - lastCpuTotal
	  var idleDiff = idleTime - lastCpuIdle
	  if (totalDiff > 0) {
	    cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
	  }
	}
	lastCpuTotal = total
	lastCpuIdle = idleTime
      }
    }
    Component.onCompleted: running = true
  }
  
  // CPU temp
  Process {
    id: cpuTempProc
    command: ["sh", "-c", "for h in /sys/class/hwmon/hwmon*; do [ \"$(cat $h/name)\" = k10temp ] && cat $h/temp1_input; done"]
    stdout: SplitParser {
      onRead: data => {
	cpuTemp = Math.round((parseInt(data) || 0) / 1000)
      }
    }
    Component.onCompleted: running = true
  }

  Process {
    id: diskProc
    command: ["sh", "-c", "df / | tail -1"]
    stdout: SplitParser {
      onRead: data => {
	if (!data) return
	var parts = data.trim().split(/\s+/)
	var percentStr = parts[4] || "0%"
	diskUsage = parseInt(percentStr.replace('%', '')) || 0
      }
    }
    Component.onCompleted: running = true
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      cpuProc.running = true
      memProc.running = true
      cpuTempProc.running = true
      diskProc.running = true
    }
  }

}
