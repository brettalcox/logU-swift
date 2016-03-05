<?php
        require 'database.php';
        $username = $_POST["username"];
  //    include 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();
	$sql0 = "select distinct lift_category.category, (CASE WHEN joined_category.weighted IS NULL THEN 0 else joined_category.weighted END) as weighted from lift_category left join (select sum(weighted) as weighted, category from (select distinct lift, date, user from workout where user = '$username') as lifts_filtered natural join lift_category where user = '$username' group by category) as joined_category on lift_category.category = joined_category.category";

        $result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result, JSON_UNESCAPED_SLASHES);

?>

