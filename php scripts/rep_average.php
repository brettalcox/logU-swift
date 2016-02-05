<?php
        require 'database.php';
        $username = $_POST["username"];
        $unit = $_POST["unit"];
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        //$row0 = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        //$sql0 = "SELECT ROUND(SUM(reps)/COUNT(reps), 2) AS average_reps, SUM(reps) AS total_reps, SUM(sets) AS total_sets, COUNT(date) as total_lifts FROM workout WHERE user = '$username'";
        $sql0 = "SELECT ROUND(SUM(reps)/COUNT(reps), 2) AS average_reps, SUM(reps) AS total_reps, SUM(sets) AS total_sets, COUNT(date) AS total_lifts, (SELECT lift AS count FROM workout WHERE user = '$username' GROUP BY lift ORDER BY COUNT(count) DESC LIMIT 1) AS count FROM workout WHERE user = '$username'";
	$row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
	echo json_encode($row, JSON_UNESCAPED_SLASHES);
?>

