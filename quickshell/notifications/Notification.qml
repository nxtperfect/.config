import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
        required property string body
        property string appName
        property bool isInFocus: false;
        Layout.preferredHeight: 64
        Layout.preferredWidth: parent.width
        Rectangle {
                height: 64
                width: dashboard.width - 16
                color: isInFocus ? "#ff00ff" : "#80ff00ff"
                Column {
                        id: content
                        width: parent.width
height: parent.height
                        Text {
                                width: parent.width
                                anchors.centerIn: content.parent
                                maximumLineCount: 1
                                text: appName
                        }
                        Text {
                                width: parent.width
                                anchors.centerIn: content.parent
                                elide: Text.ElideRight
                                maximumLineCount: 3
                                wrapMode: Text.Wrap
                                text: body
                        }
                }
        }
}
