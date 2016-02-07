<?php
        require 'database.php';
        $username = $_POST["username"];
	$unit = $_POST["unit"];
	$gender = $_POST["gender"];
	$bodyweight = $_POST["bodyweight"];
        
	ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        //$row0 = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
	$sql0 = "UPDATE users SET unit = '$unit', gender = '$gender', bodyweight = '$bodyweight' WHERE username = '$username'";
        $row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);

?>

