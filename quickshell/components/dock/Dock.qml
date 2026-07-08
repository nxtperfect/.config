import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:/config"

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
}
