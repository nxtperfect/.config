import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import "root:/config"

Item {
    height: Config.bar.barWidth
    width: Config.bar.barWidth

    RectangularShadow {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        blur: notifBubble.isHovered ? 18 : 10
        radius: 32

        Behavior on blur {
            PropertyAnimation {
                duration: 100
                easing {
                    type: Easing.InOutBack
                    overshoot: 8.0
                }
            }
        }
    }

    Rectangle {
        id: notifBubble
        property bool isHovered: hoverHandler.hovered
        property bool isOpenNotifications: false

        color: isHovered ? Colors.background : Colors.background1
        // color: "transparent"
        height: parent.height
        width: parent.width
        scale: isHovered ? 1.1 : 1.0
        radius: Config.bar.radius
        anchors {
            left: parent
            right: parent
        }

        Behavior on color {
            PropertyAnimation {
                duration: 100
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on scale {
            PropertyAnimation {
                duration: 100
                easing {
                    type: Easing.InOutBack
                    overshoot: 8.0
                }
            }
        }

        HoverHandler {
            id: hoverHandler
        }

        MouseArea {
            id: mouseArea
            cursorShape: Qt.PointingHandCursor
            propagateComposedEvents: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            onClicked: mouse => {
                if (mouse.button == Qt.LeftButton) {
                    notifBubble.isOpenNotifications = !notifBubble.isOpenNotifications;
                }
            }
        }
    }
}
