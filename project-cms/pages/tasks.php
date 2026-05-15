<?php require_once __DIR__.'/../config/database.php'; include __DIR__.'/../includes/header.php';
$tasks=$pdo->query("SELECT t.*,p.project_name,u.full_name FROM tasks t JOIN projects p ON p.id=t.project_id JOIN users u ON u.id=t.assigned_to_user_id ORDER BY t.task_deadline ASC")->fetchAll();
?>
<div class="d-flex justify-content-between mb-2"><h4>Đầu việc</h4></div>
<table class="table table-bordered table-sm"><tr><th>Dự án</th><th>Đầu việc</th><th>Người xử lý</th><th>Deadline</th><th>Trạng thái</th><th>Mức cảnh báo</th></tr>
<?php foreach($tasks as $t): $cls=''; $d=(strtotime($t['task_deadline'])-strtotime(date('Y-m-d')))/86400; if($t['task_status']==='Xong')$cls='table-success'; elseif($d<0)$cls='table-danger'; elseif($d<=3)$cls='table-warning'; ?>
<tr class="<?=$cls?>"><td><?=e($t['project_name'])?></td><td><?=e($t['task_name'])?></td><td><?=e($t['full_name'])?></td><td><?=e($t['task_deadline'])?></td><td><?=e($t['task_status'])?></td><td><?=e($t['risk_level'])?></td></tr><?php endforeach;?></table>
<?php include __DIR__.'/../includes/footer.php'; ?>
