import QtGraphicalEffects 1.0
import QtQuick 2.11

Item {
    id: iconRoot

    property string icon: ""
    property string source: ""
    property color iconColor: "#ffffff"
    property int iconSize: 20
    readonly property string resolvedSource: {
        if (source !== "")
            return source;

        if (!icon)
            return "";

        if (icon.indexOf("/") !== -1 || icon.indexOf(":") !== -1)
            return icon;

        return Qt.resolvedUrl("../Assets/" + icon + ".svg");
    }

    implicitWidth: iconSize
    implicitHeight: iconSize
    width: implicitWidth
    height: implicitHeight

    Image {
        id: iconImage

        anchors.fill: parent
        source: iconRoot.resolvedSource
        sourceSize: Qt.size(iconRoot.iconSize * 2, iconRoot.iconSize * 2)
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        visible: false
        mipmap: true
        smooth: true
    }

    ColorOverlay {
        anchors.fill: iconImage
        source: iconImage
        color: iconRoot.iconColor
        visible: iconImage.status === Image.Ready
    }

}
