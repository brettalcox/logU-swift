<?php
        require 'database.php';
        $username = $_POST["username"];
  //    include 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
	$sql0 = "select ROUND(AVG(frequency),2) as average_freq from (SELECT COUNT(DISTINCT(date)) as frequency, WEEK(str_to_date(date, '%m/%d/%Y')) AS week from poundage WHERE user = '$username' GROUP BY YEARWEEK(str_to_date(date, '%m/%d/%Y')) ORDER BY (str_to_date(date, '%m/%d/%Y')) DESC) as freq_avg";

        $result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result, JSON_UNESCAPED_SLASHES);

?>

