<?php require_once __DIR__.'/../includes/functions.php';
jsonResponse(calculatePriorityScore($_GET['project_status']??'',$_GET['project_deadline']??null,$_GET['customer_level']??'',(float)($_GET['total_order_value']??0),$_GET['risk_note']??''));
