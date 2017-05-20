import QtQuick 2.7
import QtQuick.Controls 1.4

Rectangle {
    color: "white"
    
    StackView {
    
        id: calendarStack
        
        anchors.top: dayNames.bottom
        anchors.bottom: parent.bottom
        
        width: parent.width
    

        property int transitionSpeed: 400
        
        property int transitionDirection: transitionRIGHT
        readonly property int transitionRIGHT: 1
        readonly property int transitionLEFT:  2

        delegate: StackViewDelegate {
        
            pushTransition: StackViewTransition {
                PropertyAnimation {
                    target: exitItem
                    property: "x"
                    from: 0
                    to: calendarStack.transitionDirection===calendarStack.transitionRIGHT ? exitItem.width : -exitItem.width
                    duration: transitionSpeed
                }
                PropertyAnimation {
                    target: enterItem
                    property: "x"
                    from: calendarStack.transitionDirection===calendarStack.transitionRIGHT ? -exitItem.width : exitItem.width
                    to: 0
                    duration: transitionSpeed
                }
            }
        }
    }
    
    
    
    Rectangle {
        id: month
        height: 32
        width: parent.width
        anchors.top: parent.top
        border.width: 1
        border.color: "#e3e3e3"
        
        color: "#f3f3f3"
        
        Text {
        
            function setMonthName( month ){
                var monthNames = ["January","February","March","April","May",
                    "June","July","August","September","October","November","December"]
                monthName.text = monthNames[month]
            }
        
            id: monthName
            anchors.centerIn: parent
            text: "December"
            font.bold: true
        }
        
        DirectionAngle {
            id: monthButtonRight
            
            direction: "right"
            
            anchors.right: parent.right
            height: parent.height
            width: height
            
            MouseArea {
                anchors.fill: parent
                
                onClicked: {
                    calendarStack.transitionDirection = calendarStack.transitionRIGHT
                    var theDate = calendarStack.currentItem.theDate
                    theDate.setMonth( theDate.getMonth() + 1 )
                    calendarStack.push( Qt.resolvedUrl("CalendarBlock.qml"), { "theDate": theDate } );
                }
            }
        }
        
        
        DirectionAngle {
            id: monthButtonLeft
            
            anchors.left: parent.left
            height: parent.height
            width: height
            
            direction: "left"
            
            MouseArea {
                anchors.fill: parent
                
                onClicked: {
                    calendarStack.transitionDirection = calendarStack.transitionLEFT
                    var theDate = calendarStack.currentItem.theDate
                    theDate.setMonth( theDate.getMonth() - 1 )
                    calendarStack.push( Qt.resolvedUrl("CalendarBlock.qml"), { "theDate": theDate } );
                }
            }
        }
        
    }
    
    Rectangle {
        id: dayNames
        height: 24
        width: parent.width
        anchors.top: month.bottom
        border.width: 1
        border.color: "#e3e3e3"
        
        color: "#fafafa"
        
        ListModel {
            id: dayNameModel
            ListElement { name: "Sunday" }
            ListElement { name: "Monday" }
            ListElement { name: "Tuesday" }
            ListElement { name: "Wednesday" }
            ListElement { name: "Thursday" }
            ListElement { name: "Friday" }
            ListElement { name: "Saturday" }
        }
        
        GridView {
            
            id: dayNameView
        
            property real theWidth: parent.width / 7
            property real theHeight: parent.height
        
            anchors.fill: parent
            
            cellWidth: theWidth
            cellHeight: theHeight
            
            model: dayNameModel
            
            interactive: false
            
            delegate: Item {
                width: dayNameView.theWidth
                height: dayNameView.theHeight


                Text {
                    anchors { 
                        horizontalCenter: parent.horizontalCenter 
                        verticalCenter: parent.verticalCenter
                    }
                    font.pixelSize: dayNameView.theHeight/2 - 1
                    text: name
                }
            }
        }
        
    }
    
    
    Component.onCompleted: {
    
        calendarStack.push( Qt.resolvedUrl("CalendarBlock.qml"), { "theDate": new Date() } );
        
    }
}
