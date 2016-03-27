<?php
        require 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

	$sql = "SELECT latitude, longitude FROM gps_coords";

        $result = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result, JSON_UNESCAPED_SLASHES);
?>

