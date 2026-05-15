async function loadDashboard(){
 const r=await fetch('/project-cms/api/get-dashboard-data.php'); const d=await r.json();
 const k=d.kpi; const box=document.getElementById('dashboard-kpi'); if(!box) return;
 const cards=[['Tổng dự án',k.total_projects],['Đang triển khai đơn hàng',k.in_order],['Đang làm mẫu',k.in_sample],['Đang tư vấn',k.in_consult],['Hoàn thành',k.done],['Dự án trễ',k.late_projects],['Task trễ',k.late_tasks],['Tổng đơn hàng',new Intl.NumberFormat('vi-VN').format(k.total_order_value)+' đ'],['Mục tiêu',new Intl.NumberFormat('vi-VN').format(k.target_revenue)+' đ'],['Đã đạt',new Intl.NumberFormat('vi-VN').format(k.actual_revenue)+' đ'],['Tỷ lệ đạt',k.completion_rate+'%']];
 box.innerHTML=cards.map(c=>`<div class='col-md-3'><div class='card kpi-card'><div class='card-body'><div>${c[0]}</div><strong>${c[1]}</strong></div></div></div>`).join('');
 new Chart(document.getElementById('statusChart'),{type:'doughnut',data:{labels:d.status.map(x=>x.project_status),datasets:[{data:d.status.map(x=>x.c)}]}});
 new Chart(document.getElementById('priorityChart'),{type:'bar',data:{labels:d.priority.map(x=>x.priority_level),datasets:[{label:'Số dự án',data:d.priority.map(x=>x.c)}]}});
 new Chart(document.getElementById('salesChart'),{type:'bar',data:{labels:d.sales.map(x=>x.full_name),datasets:[{label:'Mục tiêu',data:d.sales.map(x=>x.target_revenue)},{label:'Đã đạt',data:d.sales.map(x=>x.actual_revenue)}]}});
}
document.addEventListener('DOMContentLoaded',loadDashboard);
