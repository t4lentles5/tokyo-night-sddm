import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Layouts 1.11

Item {
    id: topLeftRoot

    property string greetingText: {
        if (typeof config !== "undefined" && config.HeaderText && config.HeaderText.trim() !== "")
            return config.HeaderText.trim().toUpperCase();

        var h = new Date().getHours();
        if (h < 12)
            return "GOOD MORNING";

        if (h < 19)
            return "GOOD AFTERNOON";

        return "GOOD EVENING";
    }

    visible: typeof config === "undefined" || config.HeaderText !== ""
    implicitWidth: layout.implicitWidth + 32
    implicitHeight: 36

    // Soft, diffused ambient shadow matching LockScreen
    RectangularGlow {
        anchors.fill: pillBg
        glowRadius: 14
        spread: 0
        color: Qt.rgba(0, 0, 0, 0.28)
        cornerRadius: pillBg.radius
        z: -1
    }

    Rectangle {
        id: pillBg

        anchors.fill: parent
        radius: height / 2
        color: root.bgGlassColor
        border.color: root.borderColor
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius
            color: root.bgSecondaryColor
        }

        RowLayout {
            id: layout

            anchors.centerIn: parent
            spacing: 8

            SvgIcon {
                icon: "sparkles"
                iconSize: 15
                iconColor: root.accentColor
            }

            Text {
                text: topLeftRoot.greetingText
                font.family: root.fontFamily
                font.letterSpacing: 2
                font.bold: true
                font.pixelSize: 11
                color: root.fgColor
                renderType: Text.QtRendering
            }

        }

    }

}
