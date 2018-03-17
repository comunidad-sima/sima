function generaChartBarra(contenedor, datos, barColor, labels, titulo) {


    //BAR CHART
    var bar = new Morris.Bar({
        element: contenedor,
        resize: true,
        data: datos,
        barColors: [barColor],
        xkey: 'y',
        ykeys: ['a'],
        labels: [labels],
        hideHover: 'auto'
    });
}