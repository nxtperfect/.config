// inspired by https://github.com/catdeal3r/ChromeX/blob/main/.config/quickshell/services/EyeProtection.qml
import Quickshell

import QtQuick
import "root:/config"

Scope {
    id: root
    function runNotify() {
        Quickshell.execDetached(["notify-send", "Protect your eyes.", "Look at an object at least 6 meters away for 20 seconds."]);
    }

    Timer {
        interval: Config.eyeprotection.minutesBetweenHealthNotif * 60000
        running: Config.eyeprotection.minutesBetweenHealthNotif == -1 ? false : true
        repeat: Config.eyeprotection.minutesBetweenHealthNotif == -1 ? false : true
        onTriggered: root.runNotify()
    }
}
