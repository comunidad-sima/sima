function cargar_dato_pie(idPintar, labels, data, personalizada, type) {
    document.getElementById("limpiar_grafica").innerHTML="<canvas id='pieChart' width='100%' height='50px'></canvas>"
    var ctxP = document.getElementById(idPintar).getContext('2d');
    var myPieChart = new Chart(ctxP, {
        type: type,
        data: {
            labels: labels,
            datasets: [
                {
                    data: data,
                    backgroundColor: ["#F7464A", "#46BFBD", "#FDB45C", "#949FB1", "#4D5360"],
                    hoverBackgroundColor: ["#FF5A5E", "#5AD3D1", "#FFC870", "#A8B3C5", "#616774"]
                }
            ]
        },
        options: {
            responsive: true
        }
    });

}