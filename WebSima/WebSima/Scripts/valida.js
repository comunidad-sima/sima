
/**
 *  este metodo es el encargada de validar el tamaño de la evidencia que se desea subir al serviro
 * @returns {Boolean} si el tamaño del archivo pesa mas de 4MB retorna false de lo contariso true
 */
function validaTamano( inputFile) {
	var valido = true;
	var input = document.getElementById(inputFile);
	var file = input.files[0];
	if (file.size > 4000000) {
		alert("El archivo que desea subir supera el tamaño maximo(4Mb).");
		valido = false;
	} else if (input.files[0].name.length > 140) {
		alert("El archivo que desea subir tiene el nombre muy grande:\n" + input.files[0].name);
		valido = false;
	}
	return valido;
}