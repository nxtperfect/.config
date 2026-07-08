import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "root:/config"

Item {
    PanelWindow {
        id: baseDock
        property bool isHovered: hoverHandler.hovered || dockHoverHandler.hovered

        color: "transparent"
        // implicitWidth: Config.dock.width
        width: Config.dock.width
        height: Config.dock.height + Config.dock.margin
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore
        // mask: Region {}

        Behavior on exclusiveZone {
            PropertyAnimation {
                duration: 100
                easing {
                    type: Easing.InOutCubic
                    overshoot: 8.0
                }
            }
        }

        anchors {
            bottom: true
            left: true
            right: true
        }

        WrapperItem {
            id: wrapperArea
            height: parent.height / 3
            width: parent.width
            anchors.verticalCenter: parent.bottom

            HoverHandler {
                id: hoverHandler
                parent: wrapperArea
            }

            MouseArea {
                id: mouseArea
                // cursorShape: Qt.PointingHandCursor
                propagateComposedEvents: true
                // acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent
            }
        }

        WrapperMouseArea {
            height: parent.height - Config.dock.margin
            width: Config.dock.width
            y: baseDock.isHovered ? 0 : this.height * 2
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                height: parent.height
                width: parent.width

                Rectangle {
                    id: dock

                    color: Colors.background
                    height: parent.height
                    // implicitWidth: parent.width
                    implicitWidth: parent.width
                    anchors.centerIn: parent
                    radius: Config.bar.radius

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Rectangle {
                            color: "red"
                            width: Config.dock.height - Config.dock.margin
                            height: Config.dock.height - Config.dock.margin
                            radius: Config.bar.radius / 4
                        }
                        Rectangle {
                            color: "green"
                            width: Config.dock.height - Config.dock.margin
                            height: Config.dock.height - Config.dock.margin
                            radius: Config.bar.radius / 4
                        }
                        Rectangle {
                            color: "blue"
                            width: Config.dock.height - Config.dock.margin
                            height: Config.dock.height - Config.dock.margin
                            radius: Config.bar.radius / 4
                        }
                    }
                }

                HoverHandler {
                    id: dockHoverHandler
                }
                MouseArea {
                    // id: mouseArea
                    // cursorShape: Qt.PointingHandCursor
                    propagateComposedEvents: true
                    // acceptedButtons: Qt.LeftButton | Qt.RightButton
                    anchors.fill: parent
                }
            }

            Behavior on y {
                PropertyAnimation {
                    duration: 100
                    easing {
                        type: Easing.InOutCubic
                        overshoot: 8.0
                    }
                }
            }
        }
    }
}
