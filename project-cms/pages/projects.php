<?php require_once __DIR__.'/../config/database.php'; include __DIR__.'/../includes/header.php';
$q=trim($_GET['q']??''); $status=$_GET['status']??'';
$sql="SELECT p.*, c.customer_name, c.customer_type, u.full_name owner_name FROM projects p JOIN customers c ON c.id=p.customer_id JOIN users u ON u.id=p.owner_user_id WHERE p.is_archived=0";
$params=[];
if($q!==''){ $sql.=" AND (p.project_name LIKE ? OR c.customer_name LIKE ?)"; $params[]="%$q%"; $params[]="%$q%"; }
if($status!==''){ $sql.=" AND p.project_status=?"; $params[]=$status; }
$sql.=" ORDER BY FIELD(p.project_status,'Đang triển khai Đơn hàng','Triển khai mẫu','Đang tiếp cận, tư vấn','D/A hoàn thành'), p.priority_score DESC, p.project_deadline ASC, p.total_order_value DESC, FIELD(p.customer_level,'KH VIP','Lấy thường xuyên','KH thường')";
$st=$pdo->prepare($sql); $st->execute($params); $rows=$st->fetchAll();
?>
<div class="d-flex justify-content-between mb-2"><h4>Dự án</h4><a class="btn btn-primary" href="project-form.php">+ Thêm dự án</a></div>
<table class="table table-bordered table-sm"><tr><th>Mã</th><th>Tên dự án</th><th>Khách hàng</th><th>Sale</th><th>Trạng thái</th><th>Deadline</th><th>Ưu tiên</th><th>Điểm</th><th>Giá trị</th><th></th></tr>
<?php foreach($rows as $r): ?><tr><td><?=e($r['project_code'])?></td><td><?=e($r['project_name'])?></td><td><?=e($r['customer_name'])?></td><td><?=e($r['owner_name'])?></td><td><?=e($r['project_status'])?></td><td><?=e($r['project_deadline'])?></td><td><?=e($r['priority_level'])?></td><td><?=e($r['priority_score'])?></td><td><?=vn_currency($r['total_order_value'])?></td><td><a href="project-detail.php?id=<?=$r['id']?>">Chi tiết</a> | <a href="project-form.php?id=<?=$r['id']?>">Sửa</a></td></tr><?php endforeach; ?></table>
<?php include __DIR__.'/../includes/footer.php'; ?>
