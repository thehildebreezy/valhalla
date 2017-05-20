import QtQuick 2.0

Rectangle {
    id: clockOverlay
    
    y: 0
    x: 0
    width: parent.width
    height: parent.height
    
    
    color: "black"
    
    property int numSize: 48
    
    property int hours
    property string minutes
    property string seconds
    
    property int day
    property string month
    property int year
    
    
    function timeChanged() {
        var date = new Date;
        var monthNames = [
            "January", "February", "March",
            "April", "May", "June", "July",
            "August", "September", "October",
            "November", "December"
        ];
        
        hours = date.getHours()
        minutes = ("0" + date.getMinutes()).slice(-2)
        seconds = ("0" + date.getUTCSeconds()).slice(-2)
        
        day = date.getDate()
        month = monthNames[date.getMonth()]
        year = date.getFullYear()
    }
    
    readonly property bool open: y === 0

    function hide(){
        slideIn.stop()
        slideOut.start()
    }
    
    function show(){
        slideOut.stop()
        slideIn.start()
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: clockOverlay.timeChanged()
    }
    
    Item {
        
        
        height: timeItem.height + dateItem.height
        width: (timeItem.width > dateItem.width ) ? timeItem.width : dateItem.widths
        
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        
        
        Item {
            id: timeItem
            
            
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            
            height: hourText.height
            width: hourText.width + leftSep.width + minuteText.width + rightSep.width + secondText.width
            
            Text {
                id: hourText
                text: hours
                color: "white"
                font.pixelSize: numSize
            }
            Text {
                id: leftSep
                anchors.left: hourText.right
                text: ":"
                color: "white"
                font.pixelSize: numSize
            }
            Text {
                id: minuteText
                anchors.left: leftSep.right
                text: minutes
                color: "white"
                font.pixelSize: numSize
            }
            Text {
                id: rightSep
                anchors.left: minuteText.right
                text: ":"
                color: "white"
                font.pixelSize: numSize
            }
            Text {
                id: secondText
                anchors.left: rightSep.right
                text: seconds
                color: "white"
                font.pixelSize: numSize
            }
        }
        
        
        Item {
            id: dateItem
            
            height: dayText.height
            width: dayText.width + monthText.width + yearText.width
        
            anchors.top: timeItem.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            
            Text {
                id: dayText
                text: day
                color: "white"
                font.pixelSize: numSize/2
            }
            Text {
                id: monthText
                text: " " + month + " "
                color: "white"
                font.pixelSize: numSize/2
                anchors.left: dayText.right
            }
            Text {
                id: yearText
                text: year
                color: "white"
                font.pixelSize: numSize/2
                anchors.left: monthText.right
            }
        }
        
    }
    
    PropertyAnimation {
        id: slideOut
        target: clockOverlay
        property: "y"
        from: clockOverlay.y
        to: -clockOverlay.height
    }
    
    PropertyAnimation {
        id: slideIn
        target: clockOverlay
        property: "y"
        from: clockOverlay.y
        to: 0
    }
    
    MouseArea {
        anchors.fill: parent
        
        onClicked: slideOut.start()
    }
}
