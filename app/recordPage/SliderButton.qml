/*
  Copyright (C) 2013-2014 Stefano Verzegnassi

    This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; version 3.

    This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Ubuntu.Components 0.1

/*!
    Example:
    \qml
        SliderButton {
            id: sliderButton

            height: units.gu(35)
            width: units.gu(12)

            color: "#ffffff"

            onClicked: console.log("You clicked me!")
            onDragFailed: console.log("Released too early")
            onTbDragCompleted: console.log("Dragging completed!")
            onBtDragCompleted: console.log("Initial position")
            }
    }
    \endqml
*/

UbuntuShape {
    id: container

    implicitHeight: implicitWidth*3
    implicitWidth: units.gu(10)
    property real spacer: units.gu(0.25)

    property color knobColor: "#eeeeee"

    // This image is shown when knob reaches the bottom. See SliderButton-example.
    property url btDragImageUrl
    property url knobImageUrl

    // Activated when the drag is not completed
    signal dragFailed

    // Activated when knob is clicked (only when endReached is true)
    signal clicked

    // Activated when dragging from the top to the bottom
    signal tbDragCompleted

    // Activated when dragging from the bottom to the top
    signal btDragCompleted



    color: Qt.rgba(0, 0, 0, 0.25)
    radius: "medium"

    Image {
        id: btDragImage
        visible: knob.endReached
        height: parent.width
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }

        fillMode: Image.PreserveAspectFit
        smooth: true
        source: btDragImageUrl
    }

    UbuntuShape {
        id: knob
        x: spacer; y: spacer
        height: container.width - spacer*2; width: container.width - spacer*2

        borderSource: knobMouseArea.pressed ? "radius_pressed.sci" : ""
        color: container.knobColor
        radius: container.radius

        property bool endReached: false

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: knobImageUrl
        }

        MouseArea {
            id: knobMouseArea
            anchors.fill: parent
            drag.target: parent; drag.axis: Drag.YAxis
            drag.minimumY: spacer; drag.maximumY: container.height - knob.height - spacer

            onClicked: {
                if (knob.y == (container.height - knob.height - spacer))
                    sliderButton.clicked()
            }

            onReleased: {
                knob.color = container.knobColor

                if (!knob.endReached) {
                    if (knob.y < (container.height - knob.height - spacer)) {
                        knob.y = spacer
                        sliderButton.dragFailed()
                    }
                    if (knob.y == (container.height - knob.height - spacer)) {
                        sliderButton.tbDragCompleted()
                        knob.endReached = true
                    }
                }

                if (knob.endReached) {
                    if (knob.y === spacer) {
                        knob.endReached = false
                        sliderButton.btDragCompleted()
                    }
                    if (knob.y > spacer) {
                        knob.y = (container.height - knob.height - spacer)
                        sliderButton.dragFailed()
                    }
                }
            }
        }

        Behavior on y {
            UbuntuNumberAnimation {}
        }
    }

    function reset () {
        knob.endReached = false
        knob.y = spacer
    }

}


