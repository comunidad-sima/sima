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
                    backgroundColor: ["#F7464A", "#FDB45C", "#46BFBD", "#3fe85c", "#3fe85c"],
                    hoverBackgroundColor: ["#FF5A5E", "#FFC870", "#5AD3D1", "#22b126", "#616774"]
                }
            ]
        },
        options: {
            responsive: true
        }
    });

}