<?php
        require 'database.php';
        $username = $_POST["username"];
  //    include 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

	//$gender_check = "SELECT gender FROM users WHERE username = '$username'";

	//$sql0 = "select username, percentrank, rank from (SELECT username, @prev := @curr as prev, @curr := wilks_coeff as curr, @rank := IF(@prev > @curr, @rank+@ties, @rank) AS rank, @ties := IF(@prev = @curr, @ties+1, 1) AS ties, ROUND((1-@rank/@total),2) as percentrank FROM male_wilks, (SELECT @curr := null, @prev := null, @rank := 0, @ties := 1, @total := count(*) from male_wilks where wilks_coeff is not null) b WHERE wilks_coeff is not null ORDER BY wilks_coeff DESC) as percent_rank where username = '$username'";

	//$sql1 = "select username, percentrank from (SELECT username, @prev := @curr as prev, @curr := wilks_coeff as curr, @rank := IF(@prev > @curr, @rank+@ties, @rank) AS rank, @ties := IF(@prev = @curr, @ties+1, 1) AS ties, ROUND((1-@rank/@total),2) as percentrank FROM female_wilks, (SELECT @curr := null, @prev := null, @rank := 0, @ties := 1, @total := count(*) from female_wilks where wilks_coeff is not null) b WHERE wilks_coeff is not null ORDER BY wilks_coeff DESC) as percent_rank where username = '$username'";

	//foreach ($pdo->query($gender_check) as $row2) {
        //        if ($row2['gender'] == 'M') {
	//		$result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        //                echo json_encode($result, JSON_UNESCAPED_SLASHES);
	//		//echo json_encode($theResults['percentrank'], JSON_UNESCAPED_SLASHES);
	//	        //echo "cock";
        //        }
        //        if ($row2['gender'] == 'F') {
        //                $result = $pdo->query($sql1)->fetchAll(PDO::FETCH_ASSOC);
        //                echo json_encode($result, JSON_UNESCAPED_SLASHES);
        //        }
        //}
	
	$sql0 = "SELECT username, 1 + (SELECT count( * ) FROM coed_wilks a WHERE a.wilks_coeff > b.wilks_coeff ) AS rank FROM coed_wilks b where username = '$username' ORDER BY rank";

	$result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result, JSON_UNESCAPED_SLASHES);
?>

