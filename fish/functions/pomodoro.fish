function pomodoro
    if test (count $argv) -lt 2
        echo "Usage: pomo <minutes> <message>"
        echo "Example: pomo 15 'Take a break'"
        return 1
    end

    set min $argv[1]
    set -e argv[1]
    set msg (string join " " $argv)

    set sec (math "$min * 60")

    while true
        sleep $sec
        echo $msg
        notify-send -u critical -t 0 "$msg"
        sleep 5 * 60
    end
end
