import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import "root:/config"

Scope {
    id: root

    property var active: null
    property var list: Mpris.players.values
    // property var player: Mpris.players.values[2]
    readonly property var player: { var v = Mpris.players.values; for(var i=0;i<v.length;i++){if(v[i].trackTitle&&v[i].trackTitle!=="")return v[i]}; return v.length>0?v[0]:null }

    Connections {
        target: Mpris.players

        function onValuesChanged() {
            root.updateActivePlayer()
        }
    }

    function updateActivePlayer() {
        var newActive = null
        // Find the first playing player
        for (var i = 0; i < list.length; i++) {
            if (list[i]?.isPlaying) {
                newActive = list[i]
                break
            }
        }
        // Update active if changed (null when nothing is playing)
        if (active !== newActive) {
            active = newActive
        }
    }

    Component.onCompleted: {
    	updateActivePlayer();
        console.log(Mpris.players.values);
	for (var i = 0; i < list.length; i++) {
		console.log(list[i].isPlaying);
	}
    }

    PanelWindow {
        id: controller

        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors {
            top: true
        }

        implicitWidth: 500
        implicitHeight: 100

        color: "transparent"

        ColumnLayout {
            implicitWidth: parent
            implicitHeight: parent

            spacing: 0

            anchors.topMargin: 12

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Rectangle {
                id: title
                implicitWidth: parent
                implicitHeight: topbarText.font.pixelSize + Config.notifications.margin + 2
                color: Colors.background1
                anchors.topMargin: 6
                anchors.leftMargin: 12
                Text {
                    id: topbarText
                    text: "Music"
                    font.pixelSize: 18
                    Layout.topMargin: 6
                    Layout.bottomMargin: 6
                }
            }
            Rectangle {
                implicitWidth: parent
                implicitHeight: 40
                color: Colors.background

                border.color: Colors.background1
                border.width: Config.general.borderWidth

                RowLayout {
                    spacing: 4

                    Text {
                        text: "󰒮"
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked: {
                                player.previous()
                            }
                        }
                        font.pixelSize: 36
                    }

                    Text {
                        id: textPausePlay
                        text: {`${active.isPlaying ? "󰏤" : "󰐊"}`}
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked: {
                                active.togglePlaying();
                            }
                        }
                        font.pixelSize: 36
                    }

                    Text {
                        text: "󰒭"
                        MouseArea {
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked: {
                                active.next();
                            }
                        }
                        font.pixelSize: 36
                    }

                    Text {
                        id: textArtistTitle
                        text: {
                            return `${active.trackArtist || "Unknown Artist"} - ${active.trackTitle || "Unknown Title"}`;
                        }
                    }
                }
            }
        }
    }
}
