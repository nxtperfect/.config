import QtQuick
import QtQuick.Layouts
// import QtQuick.Effects
import "root:/config"
import "root:/components/io"

Item {
    height: tray.height
    width: parent.width

    // RectangularShadow {
    //     width: parent.width
    //     height: parent.height
    //     anchors.centerIn: parent
    //     blur: 0
    //     radius: Config.bar.radius
    //     offset.x: Config.bar.shadowOffsetX
    //     offset.y: Config.bar.shadowOffsetY
    // }

    RowLayout {
      spacing: 8
      Rectangle {
        height: trayColHeight + Config.bar.margin
        width: Config.general.titleWidth
        color: Colors.background1
        // anchors.top: parent
        Text {
            text: "Tray"
            rotation : 270
            width: parent.width
        }
      }
      ColumnLayout {
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
              border.width: Config.general.borderWidth
              border.color: Colors.background1

              Layout.preferredHeight: trayCol.height + Config.bar.componentPadding

              SysTray {
                  id: trayCol
              }
          }
      }
   }
}
