pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property QtObject general
    property QtObject bar
    property QtObject dock
    property QtObject notifications
    property QtObject top
    property QtObject notifs
    property QtObject shadow
    property QtObject eyeprotection

    general: QtObject {
        property int borderWidth: 2
        property int titleWidth: 10
    }

    bar: QtObject {
        property int sectionHeight: 26
        property int barWidth: 32
        property int sectionSpacing: 8
        property int componentSpacing: 15
        property int componentPadding: 20
        property int workspaceSpacing: 10
        property int sideMargin: 5
        property int margin: 32
        property int offsetTime: 1000 * 60 * 60 * 0
        property int radius: 0 // 32
        property int shadowOffsetX: 5
        property int shadowOffsetY: 5
    }

    dock: QtObject {
        property int width: 1080 - (64 * 2)
        property int height: 64
        property int margin: 16
    }

    notifications: QtObject {
        property int margin: 16
        property int dismissMiliseconds: 5000
        property int width: 300
        property int topOffset: 24
    }

    top: QtObject {
        property int height: 20
    }

    notifs: QtObject {
        property int gaps: 5
    }

    shadow: QtObject {
        property int width: 10
        property int x: 9
        property int y: 9
    }

    eyeprotection: QtObject {
        property int minutesBetweenHealthNotif: 20
    }
}
