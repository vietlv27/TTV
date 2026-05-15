<?php require_once __DIR__.'/../config/database.php'; include __DIR__.'/../includes/header.php';
$id=(int)($_GET['id']??0); $project=null;
if($id){$st=$pdo->prepare('SELECT * FROM projects WHERE id=?');$st->execute([$id]);$project=$st->fetch();}
$customers=$pdo->query('SELECT id, customer_name FROM customers ORDER BY customer_name')->fetchAll();
$users=$pdo->query('SELECT id, full_name FROM users WHERE is_active=1 ORDER BY full_name')->fetchAll();
?>
<h4><?= $id?'Sửa':'Thêm' ?> dự án</h4>
<form method="post" action="/project-cms/api/save-project.php">
<input type="hidden" name="id" value="<?=$id?>">
<input class="form-control mb-2" name="project_code" placeholder="Mã dự án" value="<?=e($project['project_code']??'')?>" required>
<input class="form-control mb-2" name="project_name" placeholder="Tên dự án" value="<?=e($project['project_name']??'')?>" required>
<select class="form-select mb-2" name="customer_id"><?php foreach($customers as $c):?><option value="<?=$c['id']?>" <?=($project['customer_id']??0)==$c['id']?'selected':''?>><?=e($c['customer_name'])?></option><?php endforeach;?></select>
<select class="form-select mb-2" name="owner_user_id"><?php foreach($users as $u):?><option value="<?=$u['id']?>" <?=($project['owner_user_id']??0)==$u['id']?'selected':''?>><?=e($u['full_name'])?></option><?php endforeach;?></select>
<input class="form-control mb-2" type="date" name="project_deadline" value="<?=e($project['project_deadline']??'')?>">
<input class="form-control mb-2" name="customer_level" value="<?=e($project['customer_level']??'KH thường')?>">
<input class="form-control mb-2" name="project_status" value="<?=e($project['project_status']??'Đang tiếp cận, tư vấn')?>">
<input class="form-control mb-2" type="number" name="total_order_value" value="<?=e($project['total_order_value']??0)?>">
<textarea class="form-control mb-2" name="risk_note" placeholder="Nguy cơ"><?=e($project['risk_note']??'')?></textarea>
<button class="btn btn-success">Lưu</button>
</form><?php include __DIR__.'/../includes/footer.php'; ?>
