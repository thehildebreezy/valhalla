import QtQuick 2.7

Rectangle {
    id: calendarBlock

    color: "white"
    
    property date theDate
    
    
    ListModel {
        id: calendarModel
    }
    
    
    GridView {
        
        id: calendarView
    
        property real theWidth: parent.width / numCols
        property real theHeight: parent.height / numRows
        
        property int numRows: 6
        property int numCols: 7
        
        property bool protect: false
    
        anchors.fill: parent
        snapMode: GridView.SnapToRow
        
        cellWidth: theWidth
        cellHeight: theHeight
    
        interactive: true
            
        model: calendarModel
        
        
        function fillMonth( date ){
            
        
            var xmlhttp = new XMLHttpRequest();
            var url = "http://localhost/valhalla/calendar/month.php?month="+date.getMonth()+"&year="+date.getYear();

            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
                    buildMonth(date, xmlhttp.responseText );
                }
            }
            xmlhttp.open("GET", url, true);
            xmlhttp.send();
        }
        
        
        function buildMonth( date, json ){
        
            var day = date.getDate()
            var month = date.getMonth()
            var year = date.getFullYear()
            
            monthName.setMonthName( date.getMonth() )
            
            var currentDate = new Date()
            
            var firstDay = new Date(date.getTime());
            firstDay.setDate(1)
            firstDay.setDate( firstDay.getDate() - firstDay.getDay() )
        
            for(var i=0; i<numCols*numRows; i++){
            
                var thisYear  = currentDate.getYear()  == firstDay.getYear()
                var thisMonth = currentDate.getMonth() == firstDay.getMonth()
                var thisDay   = currentDate.getDate()  == firstDay.getDate()
            
                var data = {}
            
                calendarModel.insert(calendarModel.count, {
                    name: firstDay.getDate(),
                    isToday: thisDay && thisMonth && thisYear,
                    isMonth: date.getMonth() === firstDay.getMonth() && date.getYear() === firstDay.getYear(),
                    data: data
                });
                firstDay.setDate(firstDay.getDate()+1)
            }
        }
        
        
        
        highlight: Rectangle { 
            width: calendarView.theWidth
            height: calendarView.theHeight
            color: "#f3f3f3" 
            //z: 1
        }
        
        delegate: Rectangle {
            width: calendarView.theWidth
            height: calendarView.theHeight
            
            border.width: 1
            border.color: "#f3f3f3"
            
            color: isToday ? "#408AE234" : "transparent"

            Text {
                anchors { 
                    horizontalCenter: parent.horizontalCenter 
                    verticalCenter: parent.verticalCenter
                }
                text: name
                
                color: isMonth ? "#333333" : "#CCCCCC"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {parent.GridView.view.currentIndex = index }
            }
        }
        
        Component.onCompleted: {
            calendarView.fillMonth( theDate )
        }
    }
    
    
}
