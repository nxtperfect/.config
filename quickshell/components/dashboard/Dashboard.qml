import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import "root:/bar"
import "root:/config"
import "root:/notifications"

PanelWindow {
    id: dashboard
    required property bool isOpen
    color: "transparent"
    width: 400 + 32 + 32
    height: 400
    anchors {
        left: true
    }
    exclusiveZone: 0
    mask: Region {
        width: isOpen ? 400 : 0
        height: isOpen ? 400 : 0
    }

    Rectangle {
        id: notificationMainContent
        width: parent.width
        height: parent.height
        x: isOpen ? 64 : -this.width
        color: Colors.background
        radius: Config.bar.radius

        Behavior on x {
            PropertyAnimation {
                duration: 500
                easing {
                    type: Easing.InOutBack
                    overshoot: 0.4
                }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent.top
            width: parent.width
            WrapperItem {
                id: top
                height: parent.height / 10
                width: parent.width
                RowLayout {
                    anchors.centerIn: parent
                    height: parent.height
                    width: parent.width
                    Text {
                        text: ">20 Pending<"
                    }
                    Text {
                        text: "Clear All"
                    }
                    Rectangle {
                        color: "blue"
                        width: parent.width / 3
                        height: 50
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: notifBubble.isOpenNotifications = false
                            enabled: dashboard.isOpen
                        }
                        Text {
                            text: "X"
                        }
                    }
                }
            }
            // Claude attempt for notifs
            // Repeater over all currently tracked notifications
            ListView {
                anchors.fill: parent
                model: Notifications.server.trackedNotifications

                delegate: Rectangle {
                    required property var modelData  // this is the Notification object

                    width: ListView.view.width
                    height: itemCol.implicitHeight + 16
                    color: "transparent"

                    ColumnLayout {
                        id: itemCol
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: 8
                            verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: modelData.appName + " — " + modelData.summary
                            color: "#cdd6f4"
                            font.bold: true
                        }

                        Text {
                            text: modelData.body
                            color: "#a6adc8"
                            wrapMode: Text.WordWrap
                            textFormat: Text.PlainText
                            Layout.fillWidth: true
                            visible: text.length > 0
                        }

                        // Dismiss button
                        Text {
                            text: "Dismiss"
                            color: "#f38ba8"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: modelData.dismiss()
                            }
                        }
                    }
                }
            }
            // END OF CLAUDE
            // WrapperItem {
            //         id: bottom
            //         ColumnLayout {
            //                 spacing: 16
            //                 // NotificationModel {}
            //                 Repeater {
            //                         model: NotificationMainServer.notiServer.trackedNotifications
            //                         Notification {
            //                                 body: "Shrex"
            //                         }
            //                 }
            //                 Notification {
            //                         appName: "Vesktop"
            //                         // body: "Where do we go with this very very very long text like if you imagine some text this would be like a relaly long one but then if it's too long then so what?"
            //                         body: "Where do we go"
            //                         isInFocus: true
            //                 }
            //                 Notification {
            //                         appName: "Librewolf"
            //                         body: "To the place I belong"
            //                 }
            //         }
            // }
        }
    }
}
