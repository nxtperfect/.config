import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import "root:/bar"
import "root:/components/dashboard"
import "root:/config"

Item {
    PanelWindow {
        id: bar
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
        }

        implicitWidth: Config.bar.barWidth + (Config.bar.sideMargin * 2)

        WrapperItem {
            margin: Config.bar.sideMargin
            width: parent.width
            height: parent.height / 3
            anchors.verticalCenter: parent.verticalCenter

            Column {
                id: mainColumn
                anchors.centerIn: parent
                height: parent.height
                width: parent.width
                spacing: Config.bar.componentSpacing

                Top {}

                Middle {}

                Bottom {}
            }
        }
    }
}
