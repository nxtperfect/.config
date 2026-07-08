import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/config"
import "root:/components/io"

Item {
    height: tray.height
    width: parent.width

    RectangularShadow {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        blur: 10
        radius: 32
    }

    Column {
        id: tray
        anchors.centerIn: parent
        spacing: Config.bar.componentSpacing
        Layout.preferredHeight: trayCol.height + Config.bar.margin
        width: Config.bar.barWidth

        Rectangle {
            implicitHeight: trayCol.height + (Config.bar.componentPadding * 2)
            width: Config.bar.barWidth
            color: Colors.background
            radius: Config.bar.radius

            Layout.preferredHeight: trayCol.height + Config.bar.componentPadding

            SysTray {
                id: trayCol
            }
        }
    }
}
