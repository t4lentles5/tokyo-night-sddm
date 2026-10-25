import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Item {
    id: authRoot

    property int selectedSessionIndex: 0
    property string currentUsername: userCombo.currentText || ((typeof userModel !== "undefined" && userModel.lastUser) ? userModel.lastUser : "")
    property alias currentUserIndex: userCombo.currentIndex
    property bool authFailed: false
    property bool authenticating: false
    property bool capsLockOn: false

    function forceFocus() {
        passwordInput.forceActiveFocus();
    }

    function submitLogin() {
        if (passwordInput.text.length === 0)
            return ;

        authenticating = true;
        authFailed = false;
        if (typeof sddm !== "undefined")
            sddm.login(authRoot.currentUsername, passwordInput.text, authRoot.selectedSessionIndex);

    }

    onCurrentUsernameChanged: {
        faceImage.source = authRoot.currentUsername ? ("/home/" + authRoot.currentUsername + "/.face") : "";
    }
    implicitWidth: 400
    implicitHeight: contentLayout.implicitHeight + 48
    width: implicitWidth
    height: implicitHeight
    Component.onCompleted: {
        forceFocus();
    }

    ComboBox {
        id: userCombo

        visible: false
        model: (typeof userModel !== "undefined") ? userModel : null
        currentIndex: (typeof userModel !== "undefined" && userModel.lastIndex !== undefined) ? userModel.lastIndex : 0
        textRole: "name"
    }

    Connections {
        function onLoginFailed() {
            authRoot.authenticating = false;
            authRoot.authFailed = true;
            passwordInput.text = "";
            shakeAnim.restart();
            authRoot.forceFocus();
        }

        function onLoginSucceeded() {
            authRoot.authenticating = false;
            authRoot.authFailed = false;
        }

        target: (typeof sddm !== "undefined") ? sddm : null
    }

    RectangularGlow {
        anchors.fill: cardBg
        glowRadius: 24
        spread: 0
        color: Qt.rgba(0, 0, 0, 0.3)
        cornerRadius: cardBg.radius
        z: -1
    }

    Rectangle {
        id: cardBg

        anchors.fill: parent
        radius: 20
        color: root.bgGlassColor
        border.color: authRoot.authFailed ? root.accentComplementaryColor : (passwordInput.activeFocus ? root.accentColor : root.borderColor)
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius
            color: root.bgSecondaryColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: authRoot.forceFocus()
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 200
            }

        }

    }

    ColumnLayout {
        id: contentLayout

        anchors.centerIn: parent
        width: parent.width - 48
        spacing: 20

        RowLayout {
            id: userHeaderRow

            Layout.alignment: Qt.AlignLeft
            spacing: 12

            Rectangle {
                id: avatarOuter

                Layout.alignment: Qt.AlignVCenter
                width: 52
                height: 52
                radius: width / 2
                color: "transparent"
                border.color: userHeaderMouse.containsMouse ? root.accentComplementaryColor : root.accentColor
                border.width: 1.5

                Rectangle {
                    id: avatarInner

                    anchors.centerIn: parent
                    width: 44
                    height: 44
                    radius: width / 2
                    color: root.bgColor

                    Image {
                        id: faceImage

                        anchors.fill: parent
                        source: authRoot.currentUsername ? ("/home/" + authRoot.currentUsername + "/.face") : ""
                        fillMode: Image.PreserveAspectCrop
                        mipmap: true
                        asynchronous: true
                        visible: false
                        onStatusChanged: {
                            if (status === Image.Error) {
                                var user = authRoot.currentUsername;
                                if (!user)
                                    return ;

                                var currentSrc = source.toString();
                                if (currentSrc.indexOf("/.face.icon") === -1 && currentSrc.indexOf("/.face") !== -1)
                                    source = "/home/" + user + "/.face.icon";

                            }
                        }
                    }

                    Rectangle {
                        id: avatarMask

                        anchors.fill: parent
                        radius: width / 2
                        visible: false
                    }

                    OpacityMask {
                        anchors.fill: avatarInner
                        source: faceImage
                        maskSource: avatarMask
                        visible: faceImage.status === Image.Ready
                    }

                    Text {
                        anchors.centerIn: parent
                        text: authRoot.currentUsername.length > 0 ? authRoot.currentUsername.charAt(0).toUpperCase() : "U"
                        font.family: root.fontFamily
                        font.pixelSize: 20
                        font.bold: true
                        color: root.accentColor
                        visible: faceImage.status !== Image.Ready
                        renderType: Text.QtRendering
                    }

                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: 150
                    }

                }

            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                RowLayout {
                    spacing: 6

                    Text {
                        text: authRoot.currentUsername
                        font.family: root.fontFamily
                        font.pixelSize: 15
                        font.bold: true
                        color: userHeaderMouse.containsMouse ? root.accentColor : root.fgColor
                        renderType: Text.QtRendering

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                    Rectangle {
                        visible: typeof userModel !== "undefined" && userModel.count > 1
                        Layout.preferredWidth: visible ? 18 : 0
                        Layout.preferredHeight: visible ? 18 : 0
                        width: visible ? 18 : 0
                        height: visible ? 18 : 0
                        radius: 9
                        color: userHeaderMouse.containsMouse ? root.accentColor : root.bgSecondaryColor

                        Text {
                            anchors.centerIn: parent
                            text: "▾"
                            font.pixelSize: 10
                            color: userHeaderMouse.containsMouse ? root.bgColor : root.mutedColor
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }

                        }

                    }

                }

                Text {
                    text: "@" + ((typeof sddm !== "undefined" && sddm.hostName) ? sddm.hostName : "arch")
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    color: root.mutedColor
                    renderType: Text.QtRendering
                }

            }

        }

        // Styled Password Input Box
        Rectangle {
            id: inputContainer

            Layout.fillWidth: true
            Layout.preferredHeight: 46
            radius: 14
            color: root.bgSecondaryColor
            border.color: authRoot.authFailed ? root.accentComplementaryColor : (passwordInput.activeFocus ? root.accentColor : root.borderColor)
            border.width: passwordInput.activeFocus ? 2 : 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 10
                spacing: 10

                SvgIcon {
                    icon: "lock"
                    iconSize: 18
                    iconColor: authRoot.authFailed ? root.accentComplementaryColor : (passwordInput.activeFocus ? root.accentColor : root.mutedColor)
                    Layout.alignment: Qt.AlignVCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    // Placeholder and cursor when empty
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        visible: passwordInput.text.length === 0 && !authRoot.authenticating

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 2
                            height: 18
                            radius: 1
                            color: root.accentColor
                            visible: passwordInput.activeFocus
                            opacity: cursorTimer.cursorVisible ? 1 : 0
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Type password to unlock..."
                            font.family: root.fontFamily
                            font.pixelSize: 13
                            color: root.mutedColor
                            opacity: passwordInput.activeFocus ? 0.9 : 0.6
                            renderType: Text.QtRendering
                        }

                    }

                    // Authenticating text
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Verifying..."
                        font.family: root.fontFamily
                        font.pixelSize: 13
                        color: root.accentColor
                        font.bold: true
                        visible: authRoot.authenticating
                        renderType: Text.QtRendering
                    }

                    // Password dots when typing
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        visible: passwordInput.text.length > 0 && !authRoot.authenticating

                        Repeater {
                            model: passwordInput.text.length

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 8
                                height: 8
                                radius: 4
                                color: root.accentColor
                            }

                        }

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 2
                            height: 16
                            radius: 1
                            color: root.accentColor
                            visible: passwordInput.activeFocus
                            opacity: cursorTimer.cursorVisible ? 1 : 0
                        }

                    }

                    Timer {
                        id: cursorTimer

                        property bool cursorVisible: true

                        interval: 500
                        running: passwordInput.activeFocus
                        repeat: true
                        onTriggered: cursorVisible = !cursorVisible
                    }

                }

                // Action button (rocket/spinner)
                Item {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignVCenter

                    SvgIcon {
                        anchors.centerIn: parent
                        icon: "reload"
                        iconSize: 18
                        iconColor: root.accentColor
                        visible: authRoot.authenticating

                        RotationAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 1000
                            loops: Animation.Infinite
                            running: authRoot.authenticating
                        }

                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: passwordInput.text.length > 0 ? root.accentColor : "transparent"
                        opacity: passwordInput.text.length > 0 ? 0.9 : 0
                        visible: !authRoot.authenticating

                        SvgIcon {
                            anchors.centerIn: parent
                            icon: "rocket"
                            iconSize: 15
                            iconColor: root.bgColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: authRoot.submitLogin()
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }

                        }

                    }

                }

            }

            // Invisible real native input handling all keystrokes
            TextInput {
                id: passwordInput

                anchors.fill: parent
                opacity: 0
                echoMode: TextInput.Password
                focus: true
                onTextChanged: {
                    if (text.length > 0)
                        authRoot.authFailed = false;

                }
                onAccepted: {
                    authRoot.submitLogin();
                }
                Keys.onEscapePressed: {
                    passwordInput.text = "";
                    authRoot.authFailed = false;
                }
                Keys.onPressed: {
                    authRoot.capsLockOn = (event.modifiers & Qt.ShiftModifier) ? false : (event.key >= Qt.Key_A && event.key <= Qt.Key_Z && event.text.length > 0 && event.text === event.text.toUpperCase());
                }
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }

            }

        }

        // Status text / Hint / CapsLock warning
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (authRoot.authFailed)
                    return "Incorrect password. Please try again.";

                if (authRoot.authenticating)
                    return "Verifying credentials...";

                if (authRoot.capsLockOn)
                    return "Warning: Caps Lock is on";

                return "Press Enter to unlock • Esc to clear";
            }
            font.family: root.fontFamily
            font.pixelSize: 11
            color: (authRoot.authFailed || authRoot.capsLockOn) ? root.accentComplementaryColor : root.mutedColor
            font.bold: authRoot.authFailed || authRoot.capsLockOn
            renderType: Text.QtRendering

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }

            }

        }

    }

    // Shake animation on authentication failure
    SequentialAnimation {
        id: shakeAnim

        NumberAnimation {
            target: shakeTranslate
            property: "x"
            from: 0
            to: -14
            duration: 50
        }

        NumberAnimation {
            target: shakeTranslate
            property: "x"
            from: -14
            to: 14
            duration: 50
        }

        NumberAnimation {
            target: shakeTranslate
            property: "x"
            from: 14
            to: -10
            duration: 50
        }

        NumberAnimation {
            target: shakeTranslate
            property: "x"
            from: -10
            to: 10
            duration: 50
        }

        NumberAnimation {
            target: shakeTranslate
            property: "x"
            from: 10
            to: 0
            duration: 50
        }

    }

    MouseArea {
        id: userHeaderMouse

        x: contentLayout.x + userHeaderRow.x
        y: contentLayout.y + userHeaderRow.y
        width: userHeaderRow.width
        height: userHeaderRow.height
        hoverEnabled: true
        enabled: typeof userModel !== "undefined" && userModel.count > 1
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (userPopup.opened)
                userPopup.close();
            else
                userPopup.open();
        }
    }

    // Multi-user selection popup
    Popup {
        id: userPopup

        x: Math.round((authRoot.width - width) / 2)
        y: contentLayout.y + userHeaderRow.y + userHeaderRow.height + 10
        width: 250
        implicitHeight: Math.min(260, userList.contentHeight + 16)
        padding: 8

        background: Rectangle {
            radius: 14
            color: root.bgGlassColor
            border.color: root.borderColor
            border.width: 1

            RectangularGlow {
                anchors.fill: parent
                glowRadius: 16
                spread: 0
                color: Qt.rgba(0, 0, 0, 0.35)
                cornerRadius: 14
                z: -1
            }

        }

        contentItem: ListView {
            id: userList

            clip: true
            model: (typeof userModel !== "undefined") ? userModel : null

            delegate: ItemDelegate {
                width: parent.width
                height: 44
                padding: 6
                onClicked: {
                    userCombo.currentIndex = index;
                    userPopup.close();
                    passwordInput.text = "";
                    authRoot.forceFocus();
                }

                contentItem: RowLayout {
                    spacing: 10

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        color: root.bgSecondaryColor
                        border.color: index === authRoot.currentUserIndex ? root.accentColor : root.borderColor
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: (model.name && model.name.length > 0) ? model.name.charAt(0).toUpperCase() : "U"
                            font.family: root.fontFamily
                            font.pixelSize: 12
                            font.bold: true
                            color: index === authRoot.currentUserIndex ? root.accentColor : root.fgColor
                        }

                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            text: model.realName ? model.realName : (model.name || "")
                            color: index === authRoot.currentUserIndex ? root.accentColor : root.fgColor
                            font.family: root.fontFamily
                            font.pixelSize: 13
                            font.bold: index === authRoot.currentUserIndex
                            elide: Text.ElideRight
                            renderType: Text.QtRendering
                        }

                        Text {
                            visible: model.realName && model.realName !== model.name
                            text: "@" + (model.name || "")
                            color: root.mutedColor
                            font.family: root.fontFamily
                            font.pixelSize: 10
                            renderType: Text.QtRendering
                        }

                    }

                    Text {
                        visible: index === authRoot.currentUserIndex
                        text: "✓"
                        color: root.accentColor
                        font.pixelSize: 12
                        font.bold: true
                    }

                }

                background: Rectangle {
                    radius: 8
                    color: parent.hovered ? root.bgSecondaryColor : (index === authRoot.currentUserIndex ? root.bgTertiaryColor : "transparent")
                }

            }

        }

    }

    transform: Translate {
        id: shakeTranslate
    }

}
