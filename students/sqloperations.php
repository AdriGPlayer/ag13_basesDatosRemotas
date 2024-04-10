<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "ag13_basesdedatosremotas";
    $table = "estudiantes";
  //This command came from the app, you will see it soon 
  $action = $_POST["action"];
     
  // Create Connection
  $conn = new mysqli($servername, $username, $password, $dbname);
  // Check Connection
  if($conn->connect_error){
      die("Connection Failed: " . $conn->connect_error);
      return;
  } 
  // If connection is OK...

  // For table creation, temporal table maybe for shopping cart and so on 
  if("CREATE_TABLE" == $action){
      $sql = "CREATE TABLE IF NOT EXISTS $table ( 
          id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
          nombre VARCHAR(50) NOT NULL,
          apellidoPaterno VARCHAR(50) NOT NULL,
          apellidoMaterno VARCHAR(50) NOT NULL,
          telefono VARCHAR(50) NOT NULL,
          correoElectronico VARCHAR(50) NOT NULL
          )";

      if($conn->query($sql) === TRUE){
          // send back success message
          echo "success";
      }else{
          echo "error";
      }
      $conn->close();
      return;
  }

  //SELECT ALL THE DATA
  if("SELECT_TABLE" == $action){
       $database_data = array();         
       $sql = "SELECT 
          id ,
          nombre,
          apellidoPaterno,
          apellidoMaterno,
          telefono,
          correoElectronico
          FROM $table ORDER BY id DESC";
          $result = $conn->query($sql);
          
      if($result->num_rows>0){
          while($row = $result->fetch_assoc()){
              $database_data[]=$row;
          }
          echo json_encode($database_data );
      }else{
          echo "error";
      }
      $conn->close();
      return;
  }

  //Save Data

  if("INSERT_DATA" == $action){
     $nombre = $_POST["nombre"];
     $apellidoPaterno = $_POST["apellidoPaterno"];
     $apellidoMaterno = $_POST["apellidoMaterno"];
     $telefono = $_POST["telefono"];
     $correoElectronico = $_POST["correoElectronico"];
     $sql = "INSERT INTO $table (nombre,apellidoPaterno,apellidoMaterno,telefono,correoElectronico)VALUES('$nombre','$apellidoPaterno','$apellidoMaterno','$telefono','$correoElectronico')";      
     $result = $conn->query($sql);
     echo "success";            
     $conn->close();
     return;
 }
 
 //Update Data
if("UPDATE_DATA" == $action){
  $id = $_POST["id"];
  $nombre = $_POST["nombre"];
  $apellidoPaterno = $_POST["apellidoPaterno"];
  $apellidoMaterno = $_POST["apellidoMaterno"];
  $telefono = $_POST["telefono"];
  $correoElectronico = $_POST["correoElectronico"];
  $sql = "UPDATE $table SET nombre='$nombre', apellidoPaterno='$apellidoPaterno', apellidoMaterno='$apellidoMaterno', telefono='$telefono', correoElectronico='$correoElectronico' WHERE id=" . (int)$id;
  $result = $conn->query($sql);
  if($result === TRUE){
      echo "success";
  }else{
      echo "error";
  }
  $conn->close();
  return;
}

//Eliminar Datos
if("DELETE_DATA" == $action){
   $id = $_POST["id"];
   $sql = "DELETE FROM $table WHERE id=" . (int)$id;
   $result = $conn->query($sql);
   if($result === TRUE){
       echo "success";
   }else{
       echo "error";
   }
   $conn->close();
   return;
}
  ?>