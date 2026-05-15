<?php require_once __DIR__.'/../config/database.php'; include __DIR__.'/../includes/header.php'; ?>
<div id="dashboard-kpi" class="row g-3"></div>
<div class="row mt-3">
 <div class="col-md-6"><canvas id="statusChart"></canvas></div>
 <div class="col-md-6"><canvas id="priorityChart"></canvas></div>
</div>
<div class="row mt-3"><div class="col-md-12"><canvas id="salesChart"></canvas></div></div>
<?php include __DIR__.'/../includes/footer.php'; ?>
