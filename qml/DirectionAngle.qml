import QtQuick 2.4

Canvas {
    id: canvas

    antialiasing: true

    property string direction: "right"
    
    property color angleColor: "#AAAAAA"

    onPaint: {
        var ctx = canvas.getContext('2d')

        ctx.strokeStyle = angleColor
        ctx.lineWidth = canvas.height * 0.05
        ctx.beginPath()
        ctx.moveTo( (direction==="right") ? canvas.width/4 : canvas.width*3/4 ,  canvas.height*0.2 )
        ctx.lineTo( (direction==="right") ? canvas.width*3/5 : canvas.width*2/5, canvas.height * 0.5 )
        ctx.lineTo( (direction==="right") ? canvas.width/4 : canvas.width*3/4 ,  canvas.height - canvas.height*0.2 )
        ctx.stroke()
    }
}
