import QtQuick 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: panelDrawer
    
    color: "#00FFFFFF"
    
    property int menuHeight: 96
    property int slideDuration: 400
    property int senseHeight: 24
    
    property Item blur: null
    
    property bool open: false
    
    
    width: parent.width
    height: menuHeight
    
    
    readonly property real menuProgressOpening: (parent.height - panelDrawer.y) / panelDrawer.height
    readonly property int openY: parent.height - panelDrawer.height
    readonly property int closedY: parent.height
    
    readonly property real velocityThreshold: 4 * (parent.height/320)
    readonly property int pullThreshold: parent.height - (panelDrawer.menuHeight/2)
    
    function show() { open: true }
    function hide() { open: false }
    
    function toggle() { open ? open = false : open = true }
    
    // got to set dynamically
    function setup() {
    
        slideAnimation.enabled = false;
        panelDrawer.y = closedY;
        slideAnimation.enabled = true;
    }
    
    
    Connections {
        target: parent
        onHeightChanged: {
            setup()
        }
    }
    
    // for free
    x: 0
    
    onOpenChanged: completeSlideDirection()
    
    Behavior on y {
        id: slideAnimation
        NumberAnimation {
            duration: panelDrawer.slideDuration
            easing.type: Easing.OutQuad
        }
    }
    
    
    function completeSlideDirection() {
        if( panelDrawer.open ) {
            panelDrawer.y = openY
        } else {
            panelDrawer.y = closedY
        }
    }
    
    MouseArea {
    
        id: mousing
    
        property int velocity: 0
        property int oldMouseY: -1
    
        propagateComposedEvents: true
        preventStealing: true
    
        parent: panelDrawer.parent
        anchors.bottom: panelDrawer.top
        
        height: panelDrawer.y === closedY ? panelDrawer.senseHeight : panelDrawer.y
        width: panelDrawer.width
        
        drag {
            target: panelDrawer
            axis: Drag.YAxis
            minimumY: panelDrawer.parent.height - panelDrawer.height
            maximumY: panelDrawer.parent.height
        }
        
        onClicked: {
            if( panelDrawer.open ) panelDrawer.open = false
        }
        
        
        onReleased: {
            if ( velocity > panelDrawer.velocityThreshold) {
                panelDrawer.open = false
                completeSlideDirection()
            } else if ( velocity < -panelDrawer.velocityThreshold) {
                panelDrawer.open = true
                completeSlideDirection()
            } else if ( panelDrawer.y < panelDrawer.pullThreshold ) {
                panelDrawer.open = true
                panelDrawer.y = openY
            } else {
                panelDrawer.open = false
                panelDrawer.y = closedY
            }
        }
        
        
        onMouseYChanged: {
            velocity = (mouse.y - oldMouseY);
            oldMouseY = mouse.y;
        }
        
        
        
    }
    
    Rectangle {
        id: panelShadow
        
        opacity: panelDrawer.menuProgressOpening
        
        anchors.bottom: panelDrawer.top
        height: 8
        width: parent.width
        
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#33000000" }
            GradientStop { position: 0.0; color: "#00000000" }
        }
        
    }
    
    Rectangle {
        id: dropClock
        
        opacity: panelDrawer.menuProgressOpening
        
        y: -parent.y -24 + (24*panelDrawer.menuProgressOpening)
        
        color: "red"
        
        width: parent.width
        height: 24
        
        
    }
    
}
