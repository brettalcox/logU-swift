<?php
        require 'database.php';
        $username = $_POST["username"];
        $unit = $_POST["unit"];
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        //$row0 = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        $sql0 = "SELECT ROUND(SUM(reps)/COUNT(reps), 2) AS average_reps, SUM(reps) AS total_reps, SUM(sets) AS total_sets, COUNT(date) as total_lifts FROM workout WHERE user = '$username'";
        $row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);

?>

