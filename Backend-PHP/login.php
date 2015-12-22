<?php
    header("Content-type:text/html;charset=utf-8");
    require_once('dbconst.php');
    if (file_get_contents("php://input") != null) {
        $str = file_get_contents("php://input");
    }
    $arr = json_decode($str);        
    $conn=mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME)or die(json_encode(array('status' => 'false')));
    $username=mysqli_real_escape_string($conn,trim($arr->username));
    $password=mysqli_real_escape_string($conn,trim($arr->password));
    if ($username=="" || $password=="")
        die(json_encode(array('status' => 'false')));
    $check_login="SELECT * from user where username='$username' and password=SHA('$password')";
    $rst=mysqli_query($conn,$check_login)or die(json_encode(array('status' => 'false')));
    if(mysqli_num_rows($rst)==1)
    {
        $row=mysqli_fetch_array($rst);
        $update_status="UPDATE user SET online=true, last_login_time=now() where username='$username'";
        $resp = array('status' => 'true', 'highscore' => $row["highscore"], 'speedhighscore' => $row["speed_highscore"]);
        echo json_encode($resp);
    }
    else die(json_encode(array('status' => 'false')));
?>