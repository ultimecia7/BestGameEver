<?php
	header("Content-type:text/html;charset=utf-8");
    require_once('dbconst.php');
    if (file_get_contents("php://input") != null) {
        $str = file_get_contents("php://input");
    }
    $arr = json_decode($str);
    $conn=mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)or die("database connection error");
    $username=mysqli_real_escape_string($conn,trim($arr->username));
    if ($username=="")
        die("nothing to search");
    $search_friend="SELECT * FROM user WHERE username IN 
    (SELECT username2 FROM friend WHERE username1 = '$username' AND confirmed=true)";
    $rst=mysqli_query($conn,$search_friend) or die("database query error");
    $ret=array();
    while ($row=mysqli_fetch_array($rst)) {
    	$ret[] = array('username' => $row['username'], 'highscore' => $row['highscore'], 
    		'speed_highscore' => $row['speed_highscore'], 'online' => $row['online'],
    		'last_login_time' => $row['last_login_time']);
    }
    echo json_encode(array('friendList' => $ret));
?>