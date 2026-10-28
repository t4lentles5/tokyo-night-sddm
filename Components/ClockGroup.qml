import QtQuick 2.11
import QtQuick.Layouts 1.11

ColumnLayout {
    id: clockRoot

    property date currentTime: new Date()
    property bool is24h: (typeof config !== "undefined" && config.HourFormat !== "long") ? (config.HourFormat.indexOf("AP") === -1 && config.HourFormat.indexOf("ap") === -1 && config.HourFormat.indexOf("A") === -1) : true
    property string dateFormat: (typeof config !== "undefined" && config.DateFormat && config.DateFormat.trim() !== "") ? config.DateFormat.trim() : "ddd · dd MMM · yyyy"

    spacing: 12

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockRoot.currentTime = new Date();
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 4

        Text {
            id: hoursText

            text: {
                if (clockRoot.is24h)
                    return Qt.formatTime(clockRoot.currentTime, "HH");

                var h = clockRoot.currentTime.getHours() % 12 || 12;
                return (h < 10 ? "0" : "") + h;
            }
            font.family: root.fontFamily
            font.pixelSize: 84
            font.weight: Font.DemiBold
            color: root.fgColor
            renderType: Text.QtRendering
        }

        Text {
            id: colonText

            text: ":"
            font.family: root.fontFamily
            font.pixelSize: 84
            font.weight: Font.Light
            color: root.accentColor
            opacity: colonTimer.colonVisible ? 1 : 0.25
            renderType: Text.QtRendering

            Timer {
                id: colonTimer

                property bool colonVisible: true

                interval: 1000
                running: true
                repeat: true
                onTriggered: colonVisible = !colonVisible
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                }

            }

        }

        Text {
            id: minutesText

            text: Qt.formatTime(clockRoot.currentTime, "mm")
            font.family: root.fontFamily
            font.pixelSize: 84
            font.weight: Font.Light
            color: root.accentColor
            renderType: Text.QtRendering
        }

        Text {
            visible: !clockRoot.is24h
            text: clockRoot.currentTime.getHours() >= 12 ? "PM" : "AM"
            font.family: root.fontFamily
            font.pixelSize: 22
            font.bold: true
            color: root.accentColor
            Layout.alignment: Qt.AlignBaseline
            Layout.leftMargin: 8
            renderType: Text.QtRendering
        }

    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDate(clockRoot.currentTime, clockRoot.dateFormat).toUpperCase()
        font.family: root.fontFamily
        font.pixelSize: 13
        font.letterSpacing: 3
        font.bold: true
        color: root.mutedColor
        renderType: Text.QtRendering
    }

}
