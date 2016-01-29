<?php
        require 'database.php';
        ob_start();
        $pdo = Database::connect();
        ob_end_clean();

        $id = $_POST["id"];
	$sql = "DELETE FROM workout WHERE id = ?";
        $q = $pdo->prepare($sql);
        $q->execute(array($id));

        $returnValue = array("id"=>$id);
        echo json_encode($returnValue);
?>

