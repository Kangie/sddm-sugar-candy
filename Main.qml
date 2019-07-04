//
// This file is part of Sugar Dark, a theme for the Simple Display Desktop Manager.
//
// Copyright 2018 Marian Arlt
//
// Sugar Dark is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Sugar Dark is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Sugar Dark. If not, see <https://www.gnu.org/licenses/>.
//

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.ScreenWidth

    LayoutMirroring.enabled: config.ForceRightToLeft == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    padding: config.ScreenPadding
    palette.button: "transparent"
    palette.highlight: config.AccentColor
    palette.text: config.MainColor
    palette.buttonText: config.MainColor
    palette.window: config.BackgroundColor

    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    property bool leftleft: config.HaveFormBackground == "true" &&
                            config.PartialBlur == "false" &&
                            config.FormPosition == "left" &&
                            config.BackgroundImageAlignment == "left"

    property bool leftcenter: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "left" &&
                              config.BackgroundImageAlignment == "center"

    property bool rightright: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "right" &&
                              config.BackgroundImageAlignment == "right"

    property bool rightcenter: config.HaveFormBackground == "true" &&
                               config.PartialBlur == "false" &&
                               config.FormPosition == "right" &&
                               config.BackgroundImageAlignment == "center"

    Item {
        id: sizeHelper

        anchors.fill: parent
        height: parent.height
        width: parent.width

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: "black"
            opacity: config.DimBackgroundImage
            z: 1
        }

        Rectangle {
            id: formBackground
            anchors.fill: form
            anchors.centerIn: form
            color: root.palette.window
            visible: config.HaveFormBackground == "true" ? true : false
            opacity: config.PartialBlur == "true" ? 0.3 : 1
            z: 1
        }

        LoginForm {
            id: form

            height: parent.height
            width: parent.width / 2.5
            anchors.horizontalCenter: config.FormPosition == "center" ? parent.horizontalCenter : undefined
            anchors.left: config.FormPosition == "left" ? parent.left : undefined
            anchors.right: config.FormPosition == "right" ? parent.right : undefined
            z: 1
        }

        Image {
            id: backgroundImage

            height: parent.height
            width: config.HaveFormBackground == "true" && config.FormPosition != "center" && config.PartialBlur != "true" ? parent.width - formBackground.width : parent.width
            anchors.left: leftleft || 
                          leftcenter ?
                                formBackground.right : undefined

            anchors.right: rightright ||
                           rightcenter ?
                                formBackground.left : undefined

            horizontalAlignment: config.BackgroundImageHAlignment == "left" ?
                                 Image.AlignLeft :
                                 config.BackgroundImageHAlignment == "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundImageVAlignment == "top" ?
                               Image.AlignTop :
                               config.BackgroundImageVAlignment == "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            source: config.background || config.Background
            fillMode: config.ScaleImageCropped == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            sourceItem: backgroundImage
            width: form.width
            height: parent.height
            anchors.centerIn: form
            sourceRect: Qt.rect(x,y,width,height)
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }

        GaussianBlur {
            id: blur

            height: parent.height
            width: config.FullBlur == "true" ? parent.width : form.width
            source: config.FullBlur == "true" ? backgroundImage : blurMask
            radius: config.BlurRadius
            samples: config.BlurRadius * 2 + 1
            cached: true
            anchors.centerIn: config.FullBlur == "true" ? parent : form
            visible: config.FullBlur == "true" || config.PartialBlur == "true" ? true : false
        }
    }
}
