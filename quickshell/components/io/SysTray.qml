// much from Xanazf
// copied from https://github.com/FridayFaerie/quickshell/blob/main/io/SysTray.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import "root:config/"

ColumnLayout {
    id: root
    spacing: Config.bar.componentSpacing / 4
    anchors.centerIn: parent

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: toprect
            required property SystemTrayItem modelData
            color: Colors.background1
            implicitWidth: trayIcon.width + 8
            implicitHeight: trayIcon.height + 8
            radius: Config.bar.radius
            scale: isHovered ? 1.1 : 1.0
            property bool isHovered: hoverHandler.hovered

            HoverHandler {
                id: hoverHandler
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

            MouseArea {
                cursorShape: Qt.PointingHandCursor
                propagateComposedEvents: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent

                IconImage {
                    id: trayIcon
                    source: toprect.modelData.icon
                    height: Config.bar.sectionHeight - 8
                    width: Config.bar.sectionHeight - 8
                    anchors.centerIn: parent
                }

                onClicked: mouse => {
                    if (mouse.button == Qt.LeftButton) {
                        toprect.modelData.activate();
                    } else if (mouse.button == Qt.RightButton) {
                        if (!menuOpener.anchor.window) {
                            menuOpener.anchor.window = toprect.QsWindow.window;
                        }
                        if (menuOpener.visible) {
                            menuOpener.close();
                        } else {
                            menuOpener.open();
                        }
                    }
                }
            }

            QsMenuAnchor {
                id: menuOpener
                menu: toprect.modelData.menu

                anchor {
                    rect.x: 0
                    rect.y: 0

                    onAnchoring: {
                        if (anchor.window) {
                            let coords = anchor.window.contentItem.mapFromItem(toprect, 0, 0);
                            anchor.rect.x = coords.x - 6;
                            anchor.rect.y = coords.y;
                        }
                    }

                    rect.width: trayIcon.width
                    rect.height: trayIcon.height
                    gravity: Edges.Top
                    edges: Edges.Right
                    adjustment: PopupAdjustment.SlideX
                }
            }
        }
    }
}
