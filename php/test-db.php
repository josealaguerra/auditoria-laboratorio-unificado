<?php
$mysqli = new mysqli($_ENV["DB_HOST"], $_ENV["DB_USER"], $_ENV["DB_PASSWORD"], $_ENV["DB_NAME"]);
if ($mysqli->connect_error) { die("Fallo en la conexión: " . $mysqli->connect_error); }
echo "Conexión exitosa a la Base de Datos legacy: " . $mysqli->host_info;
?>