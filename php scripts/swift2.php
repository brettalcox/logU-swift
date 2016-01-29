<?php
        require 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

        $name = $_POST["name"];
        $date = $_POST["date"];
        $lift = $_POST["lift"];
        $sets = $_POST["sets"];
        $reps = $_POST["reps"];
        $weight = $_POST["weight"];
        
	$unit_check = "SELECT unit FROM users where username = '$name'";
        foreach ($pdo->query($unit_check) as $row) {
                if ($row['unit'] == 1) {
                        $unit = true;
                }
                if ($row['unit'] == 0) {
                        $unit = false;
                }
        }


	$sql = "INSERT INTO workout (user, date, lift, sets, reps, weight, unit) values(?, ?, ?, ?, ?, ?, ?)";

        $q = $pdo->prepare($sql);
        $q->execute(array($name,$date,$lift,$sets,$reps,$weight,$unit));

        $returnValue = array("date"=>$date, "lift"=>$lift, "sets"=>$sets, "reps"=>$reps, "weight"=>$weight);
        echo json_encode($returnValue);
?>

