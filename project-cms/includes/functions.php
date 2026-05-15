<?php
function e($v){ return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); }
function vn_currency($n){ return number_format((float)$n,0,',','.') . ' đ'; }
function calculatePriorityScore($status, $deadline, $customerLevel, $orderValue, $riskNote){
    $statusMap=['Đang triển khai Đơn hàng'=>40,'Triển khai mẫu'=>30,'Đang tiếp cận, tư vấn'=>20,'D/A hoàn thành'=>0];
    $customerMap=['KH VIP'=>25,'Lấy thường xuyên'=>18,'KH thường'=>10];
    $statusScore=$statusMap[$status]??0;
    $customerScore=$customerMap[$customerLevel]??0;
    $riskScore=trim((string)$riskNote)!==''?20:0;
    if(empty($deadline)){$deadlineScore=0;} else {
        $days=(int)floor((strtotime($deadline)-strtotime(date('Y-m-d')))/86400);
        $deadlineScore=$days<0?35:($days<=3?30:($days<=7?20:($days<=14?10:5)));
    }
    $v=(float)$orderValue;
    $orderScore=$v>=1000000000?25:($v>=300000000?15:($v>=50000000?8:($v>0?5:0)));
    $score=$statusScore+$deadlineScore+$customerScore+$orderScore+$riskScore;
    $level=$score>=90?'Cấp 1 - Critical':($score>=70?'Cấp 2 - High':($score>=45?'Cấp 3 - Medium':'Cấp 4 - Low'));
    return ['priority_score'=>$score,'priority_level'=>$level];
}
function jsonResponse($d){ header('Content-Type: application/json; charset=utf-8'); echo json_encode($d,JSON_UNESCAPED_UNICODE); exit; }
