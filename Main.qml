import "Components"
import QtGraphicalEffects 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Item {
    id: root

    // Dynamic Theme Properties (self-contained, no external singletons)
    property color bgColor: "#09080b"
    property color opaqueBgColor: "#09080b"
    property color fgColor: "#f1f0f4"
    property color mutedColor: "#66f1f0f4"
    property color borderColor: "#1af1f0f4"
    property color accentColor: "#8265cc"
    property color accentComplementaryColor: "#cc64c8"
    property color overlayBaseColor: "#a38fd8"
    property color bgSecondaryColor: "#0fa38fd8"
    property color bgTertiaryColor: "#05a38fd8"
    // Translucent surface for floating cards and pills, so the blurred
    // wallpaper stays visible behind them (matches the Minflair LockScreen).
    property color bgGlassColor: Qt.rgba(bgColor.r, bgColor.g, bgColor.b, bgColor.a * 0.45)
    property color bgAccentColor: "#268265cc"
    property color bgAccentComplementaryColor: "#26cc64c8"
    property color shadowColor: "#bf000000"
    property bool isDark: true
    property string wallpaperSource: "file:///var/tmp/sddm-theme/wallpaper.png"
    property string fontFamily: (typeof config !== "undefined" && config.Font) ? config.Font : "Geist"

    function loadDynamicTheme() {
        var paths = ["file:///var/tmp/sddm-theme/colorscheme.json"];
        tryLoadColors(0, paths);
        loadWallpaper();
        loadFont();
    }

    function tryLoadColors(idx, paths) {
        if (idx >= paths.length)
            return ;

        var xhr = new XMLHttpRequest();
        xhr.open("GET", paths[idx]);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    if (xhr.responseText && xhr.responseText.trim().length > 0) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            if (data.bg)
                                root.bgColor = data.bg;

                            if (data.opaqueBg)
                                root.opaqueBgColor = data.opaqueBg;

                            if (data.fg)
                                root.fgColor = data.fg;

                            if (data.muted)
                                root.mutedColor = data.muted;

                            if (data.border)
                                root.borderColor = data.border;

                            if (data.accent)
                                root.accentColor = data.accent;

                            if (data.accentComplementary)
                                root.accentComplementaryColor = data.accentComplementary;

                            if (data.overlayBase)
                                root.overlayBaseColor = data.overlayBase;

                            if (data.bgSecondary)
                                root.bgSecondaryColor = data.bgSecondary;

                            if (data.bgTertiary)
                                root.bgTertiaryColor = data.bgTertiary;

                            if (data.bgAccent)
                                root.bgAccentColor = data.bgAccent;

                            if (data.bgAccentComplementary)
                                root.bgAccentComplementaryColor = data.bgAccentComplementary;

                            if (data.shadow)
                                root.shadowColor = data.shadow;

                            if (data.isDark !== undefined)
                                root.isDark = data.isDark;

                            if (data.fontFamily)
                                root.fontFamily = data.fontFamily;
                            else if (data.font)
                                root.fontFamily = data.font;
                            return ;
                        } catch (e) {
                        }
                    }
                }
                tryLoadColors(idx + 1, paths);
            }
        };
        xhr.send();
    }

    function loadWallpaper() {
        var wallImg = "file:///var/tmp/sddm-theme/wallpaper.png";
        var xhr = new XMLHttpRequest();
        xhr.open("GET", wallImg);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || (xhr.status === 0 && xhr.responseText !== undefined))
                    root.wallpaperSource = wallImg;
                else
                    loadWallpaperText();
            }
        };
        xhr.send();
    }

    function loadWallpaperText() {
        var paths = ["file:///var/tmp/sddm-theme/current_wallpaper"];
        tryLoadWallText(0, paths);
    }

    function tryLoadWallText(idx, paths) {
        if (idx >= paths.length) {
            if (typeof config !== "undefined" && (config.Background || config.background))
                root.wallpaperSource = config.Background || config.background;

            return ;
        }
        var xhr = new XMLHttpRequest();
        xhr.open("GET", paths[idx]);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    var txt = (xhr.responseText || "").trim();
                    if (txt.length > 0) {
                        if (txt.startsWith("/")) {
                            root.wallpaperSource = "file://" + txt;
                            return ;
                        }
                    }
                }
                tryLoadWallText(idx + 1, paths);
            }
        };
        xhr.send();
    }

    function loadFont() {
        var paths = ["file:///var/tmp/sddm-theme/settings_prefs.json", "file:///var/tmp/sddm-theme/colorscheme.json"];
        tryLoadFont(0, paths);
    }

    function tryLoadFont(idx, paths) {
        if (idx >= paths.length)
            return ;

        var xhr = new XMLHttpRequest();
        xhr.open("GET", paths[idx]);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200 || xhr.status === 0) {
                    if (xhr.responseText && xhr.responseText.trim().length > 0) {
                        try {
                            var data = JSON.parse(xhr.responseText);
                            if (data.fontFamily) {
                                root.fontFamily = data.fontFamily;
                                return ;
                            } else if (data.font) {
                                root.fontFamily = data.font;
                                return ;
                            }
                        } catch (e) {
                        }
                    }
                }
                tryLoadFont(idx + 1, paths);
            }
        };
        xhr.send();
    }

    width: (typeof config !== "undefined" && config.ScreenWidth) ? config.ScreenWidth : Screen.width
    height: (typeof config !== "undefined" && config.ScreenHeight) ? config.ScreenHeight : Screen.height
    focus: true
    Component.onCompleted: {
        loadDynamicTheme();
    }
    Keys.onPressed: {
        authBox.forceFocus();
    }

    // Dynamic background with wallpaper blur, dark tint, and radial glows
    Background {
        id: bgRect
    }

    // Top-left "LOCKED" pill
    TopLeftGroup {
        id: topLeftGroup

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 32
        z: 2
    }

    // Top-right session switcher & power actions
    TopRightGroup {
        id: topRightGroup

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 32
        z: 2
    }

    // Centered layout matching LockScreen.qml: ClockGroup + AuthBox
    ColumnLayout {
        id: centerGroup

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -16
        spacing: 32
        width: Math.min(parent.width - 48, 480)
        z: 1

        ClockGroup {
            id: clockGroup

            Layout.alignment: Qt.AlignHCenter
        }

        AuthBox {
            id: authBox

            Layout.alignment: Qt.AlignHCenter
            selectedSessionIndex: topRightGroup.selectedSessionIndex
        }

    }

    // Clicking anywhere on empty background refocuses the password input
    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: {
            authBox.forceFocus();
        }
    }

}
