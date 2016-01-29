<?php
        require 'database.php';
	$username = $_POST["username"];
  //    include 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
        $sql0 = "SELECT ROUND(SUM(CASE WHEN unit = 1 THEN pounds / 2.2 ELSE pounds END), 1) as pounds, WEEK(str_to_date(date, '%m/%d/%Y')) AS week from poundage WHERE user = '$username' GROUP BY YEARWEEK(str_to_date(date, '%m/%d/%Y')) ORDER BY (str_to_date(date, '%m/%d/%Y')) ASC";
	$sql1 = "SELECT ROUND(SUM(CASE WHEN unit = 0 THEN pounds * 2.2 ELSE pounds END), 1) as pounds, WEEK(str_to_date(date, '%m/%d/%Y')) AS week from poundage WHERE user = '$username' GROUP BY YEARWEEK(str_to_date(date, '%m/%d/%Y')) ORDER BY (str_to_date(date, '%m/%d/%Y')) ASC";
        //$row0 = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);

	$unit_check = "SELECT unit FROM users where username = '$username'";
        foreach ($pdo->query($unit_check) as $row) {
                if ($row['unit'] == 1) {
                        $result = $pdo->query($sql1)->fetchAll(PDO::FETCH_ASSOC);
                        echo json_encode($result, JSON_UNESCAPED_SLASHES);
                }
                if ($row['unit'] == 0) {
                        $result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
                        echo json_encode($result, JSON_UNESCAPED_SLASHES);
                }
        }

        //$row = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        //echo json_encode($row, JSON_UNESCAPED_SLASHES);


?>

