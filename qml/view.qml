import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

ApplicationWindow {
    id: window
    width: 800
    height: 480
    visible: true

    title : "Yoooooo"

    readonly property int idleTimeSec: 30
    readonly property int idleTimeMS: idleTimeSec * 1000

    
    
    MouseArea {
        anchors.fill: parent
        
        propagateComposedEvents: true
        
        Timer {
            id: reUpTimer
            interval: idleTimeMS 
            repeat: true
            running: true
            onTriggered: {
                if( !clockDisplay.open ) clockDisplay.show()
            }
        }
        
        onPositionChanged: {
            reUpTimer.restart()
        }
        
        
        hoverEnabled: true
        

        Rectangle {
            id: homeBase
        
            anchors.fill: parent
            
            LinearGradient {
                anchors.fill: parent
                
                start: Qt.point( parent.width, 0 )
                end: Qt.point( 0, parent.height )
                
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#FF45D6FF" }
                    GradientStop { position: 1.0; color: "#FF004962" }
                }
            }
            
            PageSpace {
                id: pageSpace
            }
            
            
            
            FastBlur {
                id: fastBlur
                
                anchors.fill: pageSpace
         
                radius: 20 * panelDrawer.menuProgressOpening
                opacity: panelDrawer.menuProgressOpening 
         
                source: pageSpace
            }
            
               
            PanelDrawer {
                id: panelDrawer
                
                Panel {
                    id: panel
                }
            }
  
  
            
            ClockOverlay {
                id: clockDisplay
            }
        }
         
    }
    
    Component.onCompleted: pageSpace.push({item: Qt.resolvedUrl("Welcome.qml"), replace: true })
    
}
