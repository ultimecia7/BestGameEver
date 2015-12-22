<?php
	header("Content-type:text/html;charset=utf-8");
    require_once('dbconst.php');
    if (file_get_contents("php://input") != null) {
        $str = file_get_contents("php://input");
    }
    $arr = json_decode($str);
    $conn=mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)or die("database connection error");
    $username=mysqli_real_escape_string($conn,trim($arr->username));
    $highscore=mysqli_real_escape_string($conn,trim($arr->highscore));
    $speedHighscore=mysqli_real_escape_string($conn,trim($arr->speedhighscore));
    if ($username=="" || $highscore=="" || $speedHighscore=="")
        die("username or highscore or speedhighscore missing");
    $update_highscore="UPDATE user SET highscore = '$highscore', speed_highscore = '$speedHighscore' WHERE username = '$username'";
    $rst=mysqli_query($conn,$update_highscore)or die("database query error");
    echo "update highscore success!";
?>