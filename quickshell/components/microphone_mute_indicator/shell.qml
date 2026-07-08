import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pipewire

ShellRoot {
	Variants {
		// Create the panel once on each monitor.
		model: Quickshell.screens
                
                PanelWindow {
                        id: w

                        property var modelData
                        screen: modelData

                        anchors {
                                top: true
                        }

                        implicitWidth: content.width
                        implicitHeight: content.height
                        exclusiveZone: 0

                        margins {
                                top: 50
                        }

                        color: "transparent"

                        // Give the window an empty click mask so all clicks pass through it.
                        mask: Region {}

                        // Use the wlroots specific layer property to ensure it displays over
                        // fullscreen windows.
                        WlrLayershell.layer: WlrLayer.Overlay


                        ColumnLayout {
                                id: content
                                LazyLoader {
                                        id: muteIndicatorLoader
                                        loading: true
                                        active: true
                                        Text {
                                                id: labelMute
                                                parent: content
                                                color: "#80ff0000"
                                                font.pointSize: 22
                                                text: "Microphone Muted"
                                                visible: true
                                        }
                                }
                        }
                        Process {
                                id: muteProc
                                command: ["pamixer", "--default-source", "--get-volume-human"]
                                running: true

                                stdout: StdioCollector {
                                        onStreamFinished: {
                                                muteIndicatorLoader.item.visible = this.text.trim() === "muted" ? true : false
                                        }
                                }
                        }


                        Timer {
                                interval: 100

                                running: true

                                repeat: true

                                onTriggered: muteProc.running = true
                        }
                }
        }
}
