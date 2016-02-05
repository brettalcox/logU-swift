<?php
        require 'database.php';
        $username = $_POST["username"];
  //    include 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

 	$unit_check = "SELECT unit FROM users where username = '$username'";
	$gender_check = "SELECT gender FROM users WHERE username = '$username'";
	$weight_check = "SELECT (CASE WHEN unit = 1 THEN bodyweight / 2.2 ELSE bodyweight END) AS bodyweight FROM users WHERE username = '$username'";

	foreach ($pdo->query($unit_check) as $row0) {
		//$unit = $pdo->query($unit_check)->fetchALL(PDO::FETCH_ASSOC);
		$unit = $row0['unit'];
	}
	foreach ($pdo->query($weight_check) as $row4) {
                //$weight = $pdo->query($weight_check)->fetchALL(PDO::FETCH_ASSOC);
        	$weight = $row4['bodyweight'];
	}

        
	$sql0 = "SELECT SUM(CASE WHEN unit = 0 THEN weight * 2.2 ELSE weight END) AS total, ROUND((SUM(CASE WHEN unit = 0 THEN weight * 2.2 ELSE weight END) / 2.2) * (500 / (-216.0475144 + (16.2606339*'$weight') + (-0.002388645 * POW('$weight', 2)) + (-0.00113722 * POW('$weight',3)) + (7.01863E-06 * POW('$weight',4)) + (-1.291E-08 * POW('$weight',5)))), 0) AS wilks_coeff FROM (SELECT lift, max(weight) AS weight, user, unit FROM workout WHERE (lift = 'Squat' OR lift = 'Bench' OR lift = 'Deadlift') AND user = '$username' GROUP BY lift) AS totals";
        $sql1 = "SELECT SUM(CASE WHEN unit = 0 THEN weight * 2.2 ELSE weight END) AS total, ROUND((SUM(CASE WHEN unit = 0 THEN weight * 2.2 ELSE weight END) / 2.2) * (500 / (594.31747775582 + (-27.23842536447*'$weight') + (0.82112226871 * POW('$weight', 2)) + (-0.00930733913 * POW('$weight',3)) + (0.00004731582 * POW('$weight',4)) + (-0.00000009054 * POW('$weight',5)))), 0) AS wilks_coeff FROM (SELECT lift, max(weight) AS weight, user, unit FROM workout WHERE (lift = 'Squat' OR lift = 'Bench' OR lift = 'Deadlift') AND user = '$username' GROUP BY lift) AS totals";


	foreach ($pdo->query($gender_check) as $row2) {
		if ($row2['gender'] == 'M') {
			$result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
                        echo json_encode($result, JSON_UNESCAPED_SLASHES);
		}
		if ($row2['gender'] == 'F') {
			$result = $pdo->query($sql1)->fetchAll(PDO::FETCH_ASSOC);
                        echo json_encode($result, JSON_UNESCAPED_SLASHES);
		}
	}
?>
