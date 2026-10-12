import QtGraphicalEffects 1.0
import QtQuick 2.11

Rectangle {
    id: bgRect

    anchors.fill: parent
    color: root.bgColor

    Image {
        id: wallpaperImg

        anchors.fill: parent
        source: root.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        visible: false
        mipmap: true
    }

    FastBlur {
        id: blurredWallpaper

        anchors.fill: wallpaperImg
        source: wallpaperImg
        radius: 64
        cached: true
        visible: wallpaperImg.status === Image.Ready
    }

    // Dark tint overlay matching LockScreen (70% theme bg)
    Rectangle {
        anchors.fill: parent
        color: root.bgColor
        opacity: 0.7
    }

    // Subtle modern grid pattern
    Item {
        anchors.fill: parent
        opacity: 0.03

        Repeater {
            model: Math.ceil(parent.width / 120)

            Rectangle {
                x: index * 120
                width: 1
                height: bgRect.height
                color: root.mutedColor
            }

        }

        Repeater {
            model: Math.ceil(parent.height / 120)

            Rectangle {
                y: index * 120
                width: bgRect.width
                height: 1
                color: root.mutedColor
            }

        }

    }

    // Top-right complementary accent glow
    RadialGradient {
        anchors.fill: parent
        horizontalOffset: parent.width / 3
        verticalOffset: -parent.height / 3.5
        horizontalRadius: parent.width / 3
        verticalRadius: parent.height / 3

        gradient: Gradient {
            GradientStop {
                position: 0
                color: root.bgAccentComplementaryColor
            }

            GradientStop {
                position: 1
                color: "transparent"
            }

        }

    }

    // Bottom-left primary accent glow
    RadialGradient {
        anchors.fill: parent
        horizontalOffset: -parent.width / 3
        verticalOffset: parent.height / 3.5
        horizontalRadius: parent.width / 3
        verticalRadius: parent.height / 3

        gradient: Gradient {
            GradientStop {
                position: 0
                color: root.bgAccentColor
            }

            GradientStop {
                position: 1
                color: "transparent"
            }

        }

    }

}
