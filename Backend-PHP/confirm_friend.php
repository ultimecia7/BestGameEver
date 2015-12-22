<?php
	header("Content-type:text/html;charset=utf-8");
    require_once('dbconst.php');
    if (file_get_contents("php://input") != null) {
        $str = file_get_contents("php://input");
    }
    $arr = json_decode($str);
    $conn=mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)or die("database connection error");
    $username1=mysqli_real_escape_string($conn,trim($arr->username1));
    $username2=mysqli_real_escape_string($conn,trim($arr->username2));
    if ($username1=="" || $username2=="")
        die("username1 or username2 empty");
    $add_friend = "UPDATE friend SET confirmed=true where username1 = '$username2' AND username2 = '$username1'";
    $add_friend .= "INSERT INTO friend VALUES(NULL, '$username1', '$username2', true)";
    $rst=mysqli_multi_query($conn,$add_friend) or die("database query error");
    echo "confirm friend success!";
?>