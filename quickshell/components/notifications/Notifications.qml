import QtQuick
import QtQuick.Layouts
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
            implicitHeight: card.implicitHeight + 24

            color: "transparent"

            Timer {
                interval: popup.notification.expireTimeout > 0 ? popup.notification.expireTimeout : Config.notifications.dismissMiliseconds
                running: popup.notification.urgency !== NotificationUrgency.Critical ? true : false
                onTriggered: {
                    popup.notification.dismiss();
                    popup.destroy();
                }
            }

            Rectangle {
                id: card

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: Config.notifications.margin

                implicitWidth: Config.notifications.width
                implicitHeight: contentCol.implicitHeight + 24

                radius: Config.bar.radius
                color: Colors.background
                border.color: Colors.background1
                border.width: 1

                ColumnLayout {
                    id: contentCol
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        leftMargin: Config.bar.radius
                        rightMargin: Config.bar.radius
                        topMargin: 12
                        bottomMargin: 12
                    }
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: popup.notification.summary ? popup.notification.summary : popup.notification.appName
                            color: Colors.foreground
                            font.pixelSize: 20
                            Layout.bottomMargin: 6
                            // font.bold: true
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                            visible: text.length > 0
                        }

                        Text {
                            text: "✕"
                            color: Colors.red
                            font.pixelSize: 14

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    popup.notification.dismiss();
                                    popup.destroy();
                                }
                            }
                        }
                    }

                    Text {
                        text: popup.notification.body
                        color: Colors.foreground
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        textFormat: Text.PlainText
                        Layout.fillWidth: true
                        visible: text.length > 0
                    }
                }
            }
        }
    }
}
