pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    // Tracks "read" state ourselves, since Notification has no built-in read flag
    // We store notification IDs that have been read
    property var readIds: ({})

    // The live list of tracked notifications comes directly from the server
    property alias notifications: server.trackedNotifications

    function markRead(notification) {
        readIds[notification.id] = true;
        readIdsChanged();
    }

    function isRead(notification) {
        return readIds[notification.id] === true;
    }

    function markAllRead() {
        for (let i = 0; i < server.trackedNotifications.values.length; i++) {
            const n = server.trackedNotifications.values[i];
            readIds[n.id] = true;
        }
        readIdsChanged();
    }

    function clearAll() {
        for (let i = server.trackedNotifications.values.length - 1; i >= 0; i--) {
            server.trackedNotifications.values[i].dismiss();
        }
        readIds = {};
    }

    NotificationServer {
        id: server

        // Advertise capabilities as needed
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        keepOnReload: true

        onNotification: notif => {
            // Retain the notification so it stays in trackedNotifications
            notif.tracked = true;
        }
    }
}
