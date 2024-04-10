<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "ag13_basesdedatosremotas";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if($conn -> connect_error){
        die("Connection failed: ". $conn->connect_error);
    }
    echo "Conectado";


?>