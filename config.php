<?php
// Database configuration for 3-tier app

$host     = "mydb.cliumscw44qs.ap-south-1.rds.amazonaws.com:3306"; // RDS endpoint
$username = "admin";                                                // RDS username
$password = "Function!";                                          // RDS password (better via env var)
$database = "LoginDB";                                              // DB name

// Create connection
$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("❌ Connection failed: " . $conn->connect_error);
}
// echo "✅ Connected successfully"; // uncomment for debug
?>

