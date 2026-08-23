//@ pragma UseQApplication
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import "root:/bar"
import "root:/dock"
import "root:/components/notifications"
import "root:/components/microphone_mute_indicator"
import "root:/components/eye_protection"
import "root:/components/music_controller"
import "root:/config"

Scope {
    Bar {}
    Notifications {}
    MicrophoneMuteIndicator {}
    EyeProtection {}
    // MusicController {}
}
