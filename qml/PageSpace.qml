import QtQuick 2.7
import QtQuick.Controls 1.4

StackView {
    anchors.fill: parent

    property int transitionSpeed: 400

    delegate: StackViewDelegate {
        

        pushTransition: StackViewTransition {
            PropertyAnimation {
                target: enterItem
                property: "y"
                from: enterItem.height
                to: 0
                duration: transitionSpeed
            }
            PropertyAnimation {
                target: enterItem
                property: "scale"
                from: .3
                to: 1
                duration: transitionSpeed
            }

            
        }
    }
}


