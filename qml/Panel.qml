import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    anchors.bottom: parent.bottom
    height: 96
    width: parent.width
    color: "#40FFFFFF"
    
    
    GridLayout {
        width: parent.width - 112
        height: parent.height
        
        rows: 1
        columns: 5
        
        anchors.centerIn: parent
        
        PanelButton {
            leftColor: "#FFFFAD00"
            rightColor: "#FFFFFF41"
            page: "Calendar.qml"
        }
        
        PanelButton {
            leftColor: "#FFFF4600"
            rightColor: "#FFFFA40F"
            page: "ToDo.qml"
        }
        
        PanelButton {
            leftColor: "#FF800033"
            rightColor: "#FFFF5599"
        }
        
        PanelButton {
            leftColor: "#FF392178"
            rightColor: "#FFAA64FB"
        }
        
        
        PanelButton {
            leftColor: "#FF518A00"
            rightColor: "#FF98FF00"
        }
        
    }
}
