<?php
$host = "localhost";
$user = "root";
$database = "dbcomidas";
$pass = "";

$conexion = mysqli_connect($host, $user, $pass, $database);
if(!$conexion){
	echo "Error en la base de dato".mysqli_connect_errno();
	echo "<br>";
	echo "Depuracion del error ".mysqli_connect_error();
	exit();
}
?>