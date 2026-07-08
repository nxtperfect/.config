//@ pragma UseQApplication
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import "root:/bar"
import "root:/dock"
import "root:/components/microphone_mute_indicator"
import "root:/components/eye_protection"
import "root:/components/notifications"
import "root:/config"

Item {
    implicitWidth: 1920
    implicitHeight: 1080
    Bar {}
    Notifications {}
    MicrophoneMuteIndicator {}
    EyeProtection {}
}
