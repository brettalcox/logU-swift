<?php
        require 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

        $date = $_POST["date"];
        $lift = $_POST["lift"];
        $sets = $_POST["sets"];
        $reps = $_POST["reps"];
        $weight = $_POST["weight"];
        $intensity = $_POST["intensity"];
	$id = $_POST["id"];

        $sql = "UPDATE workout SET date = '$date', lift = '$lift', sets = '$sets', reps = '$reps', weight = '$weight', intensity = '$intensity' WHERE id = '$id'";

        $q = $pdo->prepare($sql);
        $q->execute();
?>

