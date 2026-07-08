import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import "root:/config"
import "root:/components/dashboard"

Item {
    width: parent.width
    height: Config.top.height + (Config.bar.radius * 2) + Config.bar.margin

    RectangularShadow {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        blur: 10
        radius: 32
    }

    Rectangle {
        width: parent.width
        height: parent.height
        radius: Config.bar.radius
        color: Colors.background
        anchors.top: parent

        Column {
            id: column
            anchors.centerIn: parent
            Text {
                id: weekDay
                horizontalAlignment: Text.AlignHCenter
                color: Colors.foreground

                text: {
                    Qt.formatDateTime(clock.date, "ddd");
                }
            }

            Text {
                id: hour
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                color: Colors.foreground

                text: {
                    Qt.formatDateTime(clock.date, "hh");
                }
            }

            Text {
                id: minute
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                color: Colors.foreground

                text: {
                    Qt.formatDateTime(clock.date, "mm");
                }
            }

            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }
        }
    }
}
