import QtQuick
import QtQuick.Layouts
// import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "root:/config"

Scope {
    id: root

    property alias server: notifServer

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodySupported: true
        keepOnReload: true

        onNotification: function (notif) {
            notif.tracked = true;
            popupComponent.createObject(root, {
                notification: notif
            });
        }
    }

    Component {
        id: popupComponent

        PanelWindow {
            id: popup

            required property var notification
            property bool showFirstWarningIcon: true

            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

            anchors {
                top: true
            }

            mask: Region {
                item: card
            }

            implicitWidth: Config.notifications.width
            implicitHeight: content.implicitHeight + Config.notifications.topOffset

            color: "transparent"

            // RectangularShadow {
            //     width: card.width
            //     height: content.height - content.anchors.topMargin - content.anchors.bottomMargin - (content.spacing / 2) + (card.border.width * 2)
            //     anchors.centerIn: parent
            //     blur: 0
            //     radius: 0
            //     offset.x: Config.shadow.x
            //     offset.y: Config.shadow.y
            // }

            Timer {
                interval: popup.notification.expireTimeout > 0 ? popup.notification.expireTimeout : Config.notifications.dismissMiliseconds
                running: popup.notification.urgency !== NotificationUrgency.Critical ? true : false
                onTriggered: {
                    popup.notification.dismiss();
                    popup.destroy();
                }
            }

            Timer {
                interval: 500
                running: popup.notification.urgency === NotificationUrgency.Critical
                repeat: true
                onTriggered: popup.showFirstWarningIcon = !popup.showFirstWarningIcon
            }

            ColumnLayout {
                id: content
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: Config.bar.radius
                    rightMargin: Config.bar.radius
                    topMargin: 12
                    bottomMargin: 12
                }
                spacing: topbar.height - card.anchors.margins

                Rectangle {
                    id: topbar
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Config.notifications.margin
                    color: popup.showFirstWarningIcon ? Colors.background1 : Colors.background

                    implicitHeight: topbarText.font.pixelSize + Config.notifications.margin + 2
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: 3
                        anchors.leftMargin: 6
                        Text {
                            id: topbarText
                            text: {
                                if (popup.notification.urgency !== NotificationUrgency.Critical)
                                    return "Notification";
                                return (popup.showFirstWarningIcon ? " " : " ") + "Notification";
                            }
                            color: Colors.foreground
                            font.pixelSize: 16
                            wrapMode: Text.WordWrap
                            Layout.topMargin: 6
                            Layout.bottomMargin: 6
                        }
                    }
                }


                Rectangle {
                    id: card

                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: Config.notifications.margin

                    implicitWidth: Config.notifications.width
                    implicitHeight: innerContentCol.implicitHeight + 24

                    radius: Config.bar.radius
                    color: Colors.background
                    border.color: popup.showFirstWarningIcon ? Colors.background1 : Colors.background
                    border.width: Config.general.borderWidth

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            popup.notification.dismiss();
                            popup.destroy();
                        }
                    }

                    ColumnLayout {
                        id: innerContentCol
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            leftMargin: Config.bar.radius
                            rightMargin: Config.bar.radius
                            topMargin: 12
                            bottomMargin: 12
                        }
                        spacing: -2

                        Text {
                            text: popup.notification.summary ? popup.notification.summary : popup.notification.appName
                            color: Colors.foreground
                            font.pixelSize: 14
                            Layout.bottomMargin: 6
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            Layout.leftMargin: 12
                            visible: text.length > 0
                        }

                        Text {
                            text: popup.notification.body
                            color: Colors.foreground
                            font.pixelSize: 10
                            wrapMode: Text.WordWrap
                            textFormat: Text.PlainText
                            Layout.fillWidth: true
                            Layout.leftMargin: 12
                            visible: text.length > 0
                        }
                    }
                }
            }
        }
    }
}
