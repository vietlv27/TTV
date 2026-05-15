<?php require_once __DIR__.'/../config/database.php';
$id=(int)($_POST['id']??0);
$data=[(int)$_POST['project_id'],trim($_POST['task_name']??''),(int)$_POST['assigned_to_user_id'],$_POST['task_deadline']?:null,trim($_POST['task_progress_note']??''),trim($_POST['task_status']??'Chưa làm'),trim($_POST['task_priority']??'Medium'),trim($_POST['risk_level']??'Low')];
if($id){$sql='UPDATE tasks SET project_id=?,task_name=?,assigned_to_user_id=?,task_deadline=?,task_progress_note=?,task_status=?,task_priority=?,risk_level=? WHERE id=?';$data[]=$id;} else {$sql='INSERT INTO tasks(project_id,task_name,assigned_to_user_id,task_deadline,task_progress_note,task_status,task_priority,risk_level) VALUES(?,?,?,?,?,?,?,?)';}
$pdo->prepare($sql)->execute($data);
header('Location: /project-cms/pages/tasks.php');
