<?php
        require 'database.php';
        $username = $_POST["username"];
        $unit = $_POST["unit"];
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        //$row0 = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        $sql0 = "SELECT MAX(counted) AS count, lift FROM (SELECT COUNT(*) AS counted, lift, user FROM workout WHERE user = '$username' GROUP BY lift) AS counts GROUP BY lift";
        $row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);

?>
