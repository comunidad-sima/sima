function s2ab(s) {
    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
    var view = new Uint8Array(buf);  //create uint8array as viewer
    for (var i = 0; i < s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
    return buf;
}


function esportar_a_excel(Title, Subject, data, nombre_file) {
    var wb = XLSX.utils.book_new();
    wb.Props = {
        Title: Title,
        Subject: Subject,
        Author: "SIMA"

    };
   
    wb.SheetNames.push("Reporte 1");
    //var ws_data = [data];  //a row with 2 columns
    //var ws = XLSX.utils.aoa_to_sheet(ws_data);
    var ws = XLSX.utils.json_to_sheet(data);
    wb.Sheets["Reporte 1"] = ws;

    var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });
    saveAs(new Blob([s2ab(wbout)], { type: "application/octet-stream" }), nombre_file+'.xlsx');

}
