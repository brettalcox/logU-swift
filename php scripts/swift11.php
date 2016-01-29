<?php
        require 'database.php';
        $username = $_POST["username"];
        $unit = $_POST["unit"];
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        //$row0 = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        $sql0 = "SELECT unit FROM users WHERE username = '$username'";
        $row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
	echo json_encode($row, JSON_UNESCAPED_SLASHES);

?>

