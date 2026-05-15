<?php require_once __DIR__.'/../config/database.php'; require_once __DIR__.'/../includes/functions.php';
$id=(int)($_POST['id']??0); $data=[
'project_code'=>trim($_POST['project_code']??''),'project_name'=>trim($_POST['project_name']??''),'customer_id'=>(int)($_POST['customer_id']??0),'owner_user_id'=>(int)($_POST['owner_user_id']??0),
'project_deadline'=>$_POST['project_deadline']?:null,'customer_level'=>trim($_POST['customer_level']??'KH thường'),'project_status'=>trim($_POST['project_status']??''),'total_order_value'=>(float)($_POST['total_order_value']??0),'risk_note'=>trim($_POST['risk_note']??'')
];
$pr=calculatePriorityScore($data['project_status'],$data['project_deadline'],$data['customer_level'],$data['total_order_value'],$data['risk_note']);
if($id){
$sql='UPDATE projects SET project_code=?,project_name=?,customer_id=?,owner_user_id=?,project_deadline=?,customer_level=?,project_status=?,total_order_value=?,risk_note=?,priority_score=?,priority_level=? WHERE id=?';
$pdo->prepare($sql)->execute([$data['project_code'],$data['project_name'],$data['customer_id'],$data['owner_user_id'],$data['project_deadline'],$data['customer_level'],$data['project_status'],$data['total_order_value'],$data['risk_note'],$pr['priority_score'],$pr['priority_level'],$id]);
}else{
$sql='INSERT INTO projects(project_code,project_name,customer_id,owner_user_id,project_deadline,customer_level,project_status,total_order_value,risk_note,priority_score,priority_level) VALUES(?,?,?,?,?,?,?,?,?,?,?)';
$pdo->prepare($sql)->execute([$data['project_code'],$data['project_name'],$data['customer_id'],$data['owner_user_id'],$data['project_deadline'],$data['customer_level'],$data['project_status'],$data['total_order_value'],$data['risk_note'],$pr['priority_score'],$pr['priority_level']]);
}
header('Location: /project-cms/pages/projects.php');
