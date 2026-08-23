import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
//import QtQuick.Effects
import "root:/config"

Item {
    id: root
    width: parent.width
    height: Config.top.height + (Config.bar.radius * 2) + Config.bar.margin

    // RectangularShadow {
    //     width: parent.width
    //     height: parent.height
    //     anchors.centerIn: parent
    //     blur: 0
    //     radius: Config.bar.radius
    //     offset.x: Config.bar.shadowOffsetX
    //     offset.y: Config.bar.shadowOffsetY
    // }

    Rectangle {
        width: parent.width
        height: parent.height
        radius: Config.bar.radius
        color: Colors.background
        /* anchors.top: parent */
        border.width: Config.general.borderWidth
        border.color: Colors.background1

        RowLayout {
            /* anchors.centerIn: parent */
            /* spacing: 8 */
            Rectangle {
                Layout.preferredWidth: Config.general.titleWidth
                Layout.fillHeight: true
                // width: Config.bar.TitleWidth
                color: Colors.background1
                /* anchors.left: parent */
                Text {
                    text: "Time"
                    anchors.centerIn: parent
                    transformOrigin: Item.Center
                    rotation: -90
                    // rotation : 270
                    width: parent.width
                }
            }

            ColumnLayout {
                id: column
                // Layout.preferredWidth: 50
                // Layout.fillHeight: true
                /* anchors.centerIn: parent */
                /* anchors.right: parent */
                Text {
                    id: weekDay
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
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
}
