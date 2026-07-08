pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property QtObject bar
    property QtObject dock
    property QtObject notifications
    property QtObject top
    property QtObject notifs
    property QtObject shadow
    property QtObject eyeprotection

    bar: QtObject {
        property int sectionHeight: 26
        property int barWidth: 32
        property int sectionSpacing: 8
        property int componentSpacing: 15
        property int componentPadding: 20
        property int workspaceSpacing: 10
        property int sideMargin: 10
        property int margin: 32
        property real borderWidth: 0
        property int offsetTime: 1000 * 60 * 60 * 0
        property int radius: 32
    }

    dock: QtObject {
        property int width: 1080 - (64 * 2)
        property int height: 64
        property int margin: 16
    }

    notifications: QtObject {
        property int margin: 16
        property int dismissMiliseconds: 5000
        property int width: 600
    }

    top: QtObject {
        property int height: 0
    }

    notifs: QtObject {
        property int gaps: 5
    }

    shadow: QtObject {
        property int width: 10
        property int x: 10
        property int y: 10
    }

    eyeprotection: QtObject {
        property int minutesBetweenHealthNotif: 20
    }
}
