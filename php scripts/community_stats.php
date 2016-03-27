<?php
        require 'database.php';
        $username = $_POST["username"];
        $unit = $_POST["unit"];
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        
	$sql0 = "SELECT SUM((CASE WHEN unit = 0 THEN weight * 2.2 ELSE weight END) * sets * reps) as poundage, ROUND(SUM(reps)/COUNT(reps), 2) AS average_reps, SUM(reps * sets) AS total_reps, SUM(sets) AS total_sets, COUNT(date) AS total_lifts, (SELECT lift AS count FROM workout GROUP BY lift ORDER BY COUNT(count) DESC LIMIT 1) AS favorite FROM workout";
	$row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($row, JSON_UNESCAPED_SLASHES);
?>

