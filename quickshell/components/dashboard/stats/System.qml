pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int generation: 0
    property string osTime: "1s"

    function getData() {
        let command = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}'"; // generation number
        // command += "sudo tune2fs -l /dev/sda1 | grep 'Filesystem created' | awk '{print $4} {print $5} {print $7}'" // os time

        fetcher.command[2] = command;
        fetcher.running = true;
    }

    function formatCityName(cityName) {
        return cityName.trim().split(/\s+/).join('+');
    }

    Component.onCompleted: {
        if (!root.gpsActive)
            return;
        console.info("[WeatherService] Starting the GPS service.");
        positionSource.start();
    }

    Process {
        id: fetcher
        command: ["bash", "-c", ""]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0)
                    return;
                try {
                    const parsedData = JSON.parse(text);
                    root.refineData(parsedData);
                    // console.info(`[ data: ${JSON.stringify(parsedData)}`);
                } catch (e) {
                    console.error(`[WeatherService] ${e.message}`);
                }
            }
        }
    }

    Timer {
        running: !root.generation
        repeat: false
        interval: root.fetchInterval
        triggeredOnStart: !root.generation
        onTriggered: root.getData()
    }
}
