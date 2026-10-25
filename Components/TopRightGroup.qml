import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

RowLayout {
    id: topRightRoot

    property alias selectedSessionIndex: sessionCombo.currentIndex
    property string currentSessionName: sessionCombo.currentText || "Hyprland"

    spacing: 12

    ComboBox {
        id: sessionCombo

        visible: false
        model: (typeof sessionModel !== "undefined") ? sessionModel : null
        currentIndex: (typeof sessionModel !== "undefined" && sessionModel.lastIndex !== undefined) ? sessionModel.lastIndex : 0
        textRole: "name"
    }

    // Desktop Session Capsule Pill
    Item {
        id: sessionPill

        implicitWidth: sessionLayout.implicitWidth + 28
        implicitHeight: 36

        RectangularGlow {
            anchors.fill: sessionBg
            glowRadius: 14
            spread: 0
            color: Qt.rgba(0, 0, 0, 0.28)
            cornerRadius: sessionBg.radius
            z: -1
        }

        Rectangle {
            id: sessionBg

            anchors.fill: parent
            radius: height / 2
            color: root.bgGlassColor
            border.color: sessionMouse.containsMouse ? root.accentColor : root.borderColor
            border.width: 1

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: parent.radius
                color: root.bgSecondaryColor
            }

            RowLayout {
                id: sessionLayout

                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: topRightRoot.currentSessionName
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    font.bold: true
                    color: root.fgColor
                    renderType: Text.QtRendering
                }

                Text {
                    text: "▾"
                    font.pixelSize: 10
                    color: root.mutedColor
                }

            }

            MouseArea {
                id: sessionMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (sessionPopup.opened)
                        sessionPopup.close();
                    else
                        sessionPopup.open();
                }
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }

            }

        }

        Popup {
            id: sessionPopup

            y: sessionPill.height + 8
            x: sessionPill.width - width
            width: 200
            implicitHeight: Math.min(240, sessionListView.contentHeight + 16)
            padding: 8

            background: Rectangle {
                radius: 12
                color: root.bgGlassColor
                border.color: root.borderColor
                border.width: 1

                RectangularGlow {
                    anchors.fill: parent
                    glowRadius: 16
                    spread: 0
                    color: Qt.rgba(0, 0, 0, 0.35)
                    cornerRadius: 12
                    z: -1
                }

            }

            contentItem: ListView {
                id: sessionListView

                clip: true
                model: (typeof sessionModel !== "undefined") ? sessionModel : null

                delegate: ItemDelegate {
                    width: parent.width
                    height: 36
                    onClicked: {
                        sessionCombo.currentIndex = index;
                        sessionPopup.close();
                    }

                    contentItem: Text {
                        text: model.name || ""
                        font.family: root.fontFamily
                        font.pixelSize: 12
                        color: index === topRightRoot.selectedSessionIndex ? root.accentColor : root.fgColor
                        font.bold: index === topRightRoot.selectedSessionIndex
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.QtRendering
                    }

                    background: Rectangle {
                        radius: 8
                        color: parent.hovered ? root.bgSecondaryColor : "transparent"
                    }

                }

            }

        }

    }

    // Power Actions Capsule Pill
    Item {
        implicitWidth: powerLayout.implicitWidth + 24
        implicitHeight: 36
        visible: (typeof config === "undefined" || config.ForceHideSystemButtons !== "true")

        RectangularGlow {
            anchors.fill: powerBg
            glowRadius: 14
            spread: 0
            color: Qt.rgba(0, 0, 0, 0.28)
            cornerRadius: powerBg.radius
            z: -1
        }

        Rectangle {
            id: powerBg

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
                id: powerLayout

                anchors.centerIn: parent
                spacing: 12

                // Suspend
                Item {
                    width: 26
                    height: 26

                    SvgIcon {
                        anchors.centerIn: parent
                        icon: "moon"
                        iconSize: 16
                        iconColor: suspendMouse.containsMouse ? root.accentColor : root.fgColor
                    }

                    MouseArea {
                        id: suspendMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (typeof sddm !== "undefined")
                                sddm.suspend();

                        }
                    }

                }

                // Reboot
                Item {
                    width: 26
                    height: 26

                    SvgIcon {
                        anchors.centerIn: parent
                        icon: "refresh"
                        iconSize: 16
                        iconColor: rebootMouse.containsMouse ? root.accentColor : root.fgColor
                    }

                    MouseArea {
                        id: rebootMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (typeof sddm !== "undefined")
                                sddm.reboot();

                        }
                    }

                }

                // Power Off
                Item {
                    width: 26
                    height: 26

                    SvgIcon {
                        anchors.centerIn: parent
                        icon: "power"
                        iconSize: 16
                        iconColor: powerMouse.containsMouse ? root.accentComplementaryColor : root.fgColor
                    }

                    MouseArea {
                        id: powerMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (typeof sddm !== "undefined")
                                sddm.powerOff();

                        }
                    }

                }

            }

        }

    }

}
