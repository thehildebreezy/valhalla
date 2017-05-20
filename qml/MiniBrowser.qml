import QtQuick 2.2
import QtQuick.Controls 1.1
import QtWebView 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

ApplicationWindow {
    property bool showProgress: webView.loading
                                && Qt.platform.os !== "ios"
                                && Qt.platform.os !== "winphone"
                                && Qt.platform.os !== "winrt"
    visible: true
    width: 800//initialWidth
    height: 480//initialHeight
    title: webView.title

    toolBar: ToolBar {
        id: navigationBar
        RowLayout {
            anchors.fill: parent
            spacing: 0


            DirectionAngle {
                id: backButton
                
                height: parent.height
                width: height
                
                anchors.left: parent.left
                
                direction: "left"
                
                enabled: webView.canGoBack
                
                MouseArea {
                    anchors.fill: parent
                    
                    onClicked: {
                        webView.goBack()
                    }
                }
            }
            
            
            DirectionAngle {
                id: forwardButton
                
                height: parent.height
                width: height
                
                direction: "right"
                
                anchors.left: backButton.right
                
                enabled: webView.canGoForward
                
                MouseArea {
                    anchors.fill: parent
                    
                    onClicked: {
                        webView.goForward()
                    }
                }
            }



            ToolButton {
                id: reloadButton
                tooltip: webView.loading ? qsTr("Stop"): qsTr("Refresh")
                //iconSource: webView.loading ? "images/stop-32.png" : "images/refresh-32.png"
                
                
                anchors.left: forwardButton.right
                
                Text {
                    text: "X/O"
                }
                
                onClicked: webView.loading ? webView.stop() : webView.reload()
                Layout.preferredWidth: navigationBar.height
                style: ButtonStyle {
                    background: Rectangle { color: "transparent" }
                }
            }

            Item { Layout.preferredWidth: 5 }

            TextField {
                //Layout.fillWidth: true
                id: urlField
                inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhPreferLowercase
                text: webView.url

                onAccepted: webView.url = "http://google.com" //utils.fromUserInput(text)

                anchors.left: reloadButton.right
                anchors.right: goButton.left

                ProgressBar {
                    anchors.centerIn: parent
                    //style: LoadProgressStyle { }
                    z: Qt.platform.os === "android" ? -1 : 1
                    visible: showProgress
                    minimumValue: 0
                    maximumValue: 100
                    value: webView.loadProgress == 100 ? 0 : webView.loadProgress
                }
            }

            Item { Layout.preferredWidth: 5 }

            ToolButton {
                id: goButton
                text: qsTr("Go")
                
                anchors.right: parent.right
                
                Layout.preferredWidth: navigationBar.height
                onClicked: {
                    Qt.inputMethod.commit()
                    Qt.inputMethod.hide()
                    webView.url = "http://google.com" //utils.fromUserInput(urlField.text)
                }
                style: ButtonStyle {
                    background: Rectangle { color: "transparent" }
                }
            }

            Item { Layout.preferredWidth: 10 }
        }
    }

    statusBar: StatusBar {
        id: statusBar
        visible: showProgress
        RowLayout {
            anchors.fill: parent
            Label { text: webView.loadProgress == 100 ? qsTr("Done") : qsTr("Loading: ") + webView.loadProgress + "%" }
        }
    }

    WebView {
        id: webView
        anchors.fill: parent
        url: "http://google.com" //initialUrl
    }
}
