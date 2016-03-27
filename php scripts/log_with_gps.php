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
        $intensity = $_POST["intensity"];
        $notes = $_POST["notes"];

	$latitude = $_POST["latitude"];
	$longitude = $_POST["longitude"];

        $unit_check = "SELECT unit FROM users where username = '$name'";
        foreach ($pdo->query($unit_check) as $row) {
                if ($row['unit'] == 1) {
                        $unit = true;
                }
                if ($row['unit'] == 0) {
                        $unit = false;
                }
        }


        $sql = "INSERT INTO workout (user, date, lift, sets, reps, weight, unit, intensity, notes) values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
	$sql1 = "INSERT INTO gps_coords (latitude, longitude) values(?, ?)";

        $q = $pdo->prepare($sql);
	$q1 = $pdo->prepare($sql1);

        $q->execute(array($name,$date,$lift,$sets,$reps,$weight,$unit,$intensity,$notes));
	$q1->execute(array($latitude,$longitude));	

        $returnValue = array("date"=>$date, "lift"=>$lift, "sets"=>$sets, "reps"=>$reps, "weight"=>$weight, "intensity"=>$intensity, "notes"=>$notes);
        echo json_encode($returnValue);
?>

