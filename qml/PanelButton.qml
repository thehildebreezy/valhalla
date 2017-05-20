import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: panelButton
    property color leftColor
    property color rightColor
    
    property string page: "Welcome.qml"
    
    height: 64
    width: 64
    Layout.alignment: Qt.AlignCenter
    
    
    Rectangle {
    
        id: button1
        anchors.fill: parent
        radius: 24
        
    
        LinearGradient {
            anchors.fill: parent
            source: parent
            
            start: Qt.point(parent.width, 0)
            end: Qt.point(0, parent.height)
            
            gradient: Gradient {
                GradientStop { position: 1.0; color: panelButton.leftColor }
                GradientStop { position: 0.0; color: panelButton.rightColor }
            }
        }
        
        MouseArea {
    
            id: mouseButton
            anchors.fill: parent
            
            onClicked: {
                panelDrawer.open = false
                pageSpace.push({item: Qt.resolvedUrl(page), replace: true })
            }
        }
     
    }
    
    
    DropShadow {
        anchors.fill: button1
        horizontalOffset: 0
        verticalOffset: 1
        radius: 4.0
        samples: 10
        color: "#80000000"
        source: button1
    }
    

    
}
