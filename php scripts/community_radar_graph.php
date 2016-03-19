<?php
	require 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

	$sql0 = "SELECT DISTINCT lift_category.category,
                (CASE
                     WHEN joined_category.weighted IS NULL THEN 0
                     ELSE joined_category.weighted
                 END) AS weighted
FROM lift_category
LEFT JOIN
  (SELECT sum(weighted * lifts_filtered.inol) AS weighted,
          category
   FROM
     (SELECT (
              sets * reps / (100 - (CASE WHEN workout.intensity = 100 THEN 99 ELSE workout.intensity END))) AS inol, intensity, lift, date, user
      FROM workout
      NATURAL JOIN inol
      WHERE intensity IS NOT NULL AND intensity != 0) AS lifts_filtered
   NATURAL JOIN lift_category
   GROUP BY category) AS joined_category ON lift_category.category = joined_category.category";

	$result = $pdo->query($sql0)->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($result, JSON_UNESCAPED_SLASHES);

?>
