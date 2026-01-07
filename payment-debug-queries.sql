-- بررسی پرداخت‌های در انتظار تایید ادمین در جدول PaymentAttempts
-- Check pending admin approval payments in PaymentAttempts table

-- 1. پرداخت‌های در انتظار تایید ادمین
SELECT 
    pa.Id as PaymentAttemptId,
    pa.TrackingCode,
    pa.OrderId,
    o.OrderNumber,
    pa.UserId,
    u.UserName,
    u.Email,
    pa.Amount,
    pa.Method,
    pa.Status,
    pa.ReceiptImageUrl,
    pa.ReceiptFileName,
    pa.ReceiptUploadedAt,
    pa.CreatedAt,
    DATEDIFF(day, pa.ReceiptUploadedAt, GETDATE()) as DaysWaiting
FROM PaymentAttempts pa
INNER JOIN Orders o ON pa.OrderId = o.Id
INNER JOIN AspNetUsers u ON pa.UserId = u.Id
WHERE pa.Status = 3 -- AwaitingAdminApproval
ORDER BY pa.ReceiptUploadedAt ASC;

-- 2. بررسی جدول ManualPaymentRequests (که خالی است)
SELECT COUNT(*) as ManualPaymentRequestsCount FROM ManualPaymentRequests;

-- 3. تمام وضعیت‌های PaymentAttempts
SELECT 
    Status,
    COUNT(*) as Count,
    CASE Status
        WHEN 0 THEN 'Draft'
        WHEN 1 THEN 'PendingPayment'
        WHEN 2 THEN 'AwaitingReceiptUpload'
        WHEN 3 THEN 'AwaitingAdminApproval'
        WHEN 4 THEN 'Paid'
        WHEN 5 THEN 'Failed'
        WHEN 6 THEN 'Expired'
        WHEN 7 THEN 'Refunded'
    END as StatusName
FROM PaymentAttempts
GROUP BY Status
ORDER BY Status;

-- 4. جزئیات کامل پرداخت‌های در انتظار تایید
SELECT 
    pa.Id,
    pa.TrackingCode,
    o.OrderNumber,
    u.UserName,
    u.Email,
    u.PhoneNumber,
    pa.Amount,
    pa.ReceiptImageUrl,
    pa.ReceiptFileName,
    pa.ReceiptUploadedAt,
    o.CartSnapshot, -- محتویات سبد خرید
    pa.CreatedAt,
    pa.UpdatedAt
FROM PaymentAttempts pa
INNER JOIN Orders o ON pa.OrderId = o.Id
INNER JOIN AspNetUsers u ON pa.UserId = u.Id
WHERE pa.Status = 3 -- AwaitingAdminApproval
ORDER BY pa.ReceiptUploadedAt ASC;