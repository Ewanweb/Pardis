-- PAYMENT SYSTEM REFACTORING VERIFICATION SCRIPT
-- Run this after completing the refactoring to verify everything is working correctly

-- =====================================================
-- 1. VERIFY DATABASE STRUCTURE
-- =====================================================

-- Check PaymentAttempts table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'PaymentAttempts'
ORDER BY ORDINAL_POSITION;

-- Verify constraints exist
SELECT 
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    CHECK_CLAUSE
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS 
WHERE CONSTRAINT_NAME LIKE '%PaymentAttempts%';

-- Check if ManualPaymentRequests table is removed
SELECT COUNT(*) as ManualPaymentRequestsTableExists
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'ManualPaymentRequests';

-- Verify archive tables exist
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '%Archive_20260103%';

-- =====================================================
-- 2. VERIFY DATA INTEGRITY
-- =====================================================

-- Check all PaymentAttempts have Manual method (2)
SELECT 
    Method,
    COUNT(*) as Count,
    CASE Method 
        WHEN 2 THEN 'Manual (Correct)'
        ELSE 'ERROR: Non-Manual Method Found!'
    END as Status
FROM PaymentAttempts 
GROUP BY Method;

-- Check valid status values only
SELECT 
    Status,
    COUNT(*) as Count,
    CASE 
        WHEN Status IN (0, 1, 3, 4, 5) THEN 'Valid Status'
        ELSE 'ERROR: Invalid Status Found!'
    END as Validation
FROM PaymentAttempts 
GROUP BY Status
ORDER BY Status;

-- Check for orphaned records
SELECT 
    'PaymentAttempts without Orders' as CheckType,
    COUNT(*) as Count
FROM PaymentAttempts pa
LEFT JOIN Orders o ON pa.OrderId = o.Id
WHERE o.Id IS NULL

UNION ALL

SELECT 
    'PaymentAttempts without Users' as CheckType,
    COUNT(*) as Count
FROM PaymentAttempts pa
LEFT JOIN AspNetUsers u ON pa.UserId = u.Id
WHERE u.Id IS NULL;

-- =====================================================
-- 3. VERIFY BUSINESS LOGIC
-- =====================================================

-- Check payment attempts requiring receipt upload
SELECT 
    'Pending Receipt Upload' as Category,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE Status = 1 AND (ReceiptImageUrl IS NULL OR ReceiptImageUrl = '');

-- Check payment attempts awaiting admin approval
SELECT 
    'Awaiting Admin Approval' as Category,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE Status = 3 AND ReceiptImageUrl IS NOT NULL;

-- Check completed payments
SELECT 
    'Completed Payments' as Category,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE Status = 4 AND AdminReviewedBy IS NOT NULL;

-- =====================================================
-- 4. VERIFY COURSE ENROLLMENTS
-- =====================================================

-- Check enrollments linked to payment attempts
SELECT 
    ce.PaymentStatus,
    COUNT(*) as EnrollmentCount
FROM CourseEnrollments ce
GROUP BY ce.PaymentStatus;

-- Check for free course enrollments
SELECT 
    'Free Course Enrollments' as Type,
    COUNT(*) as Count
FROM CourseEnrollments 
WHERE TotalAmount = 0 AND PaymentStatus = 2; -- Paid status for free courses

-- =====================================================
-- 5. VERIFY ADMIN WORKFLOW
-- =====================================================

-- Check pending admin reviews
SELECT 
    pa.Id as PaymentAttemptId,
    pa.TrackingCode,
    u.UserName,
    pa.Amount,
    pa.ReceiptUploadedAt,
    DATEDIFF(day, pa.ReceiptUploadedAt, GETDATE()) as DaysWaiting
FROM PaymentAttempts pa
INNER JOIN AspNetUsers u ON pa.UserId = u.Id
WHERE pa.Status = 3 -- AwaitingAdminApproval
ORDER BY pa.ReceiptUploadedAt ASC;

-- Check admin review activity
SELECT 
    AdminReviewedBy,
    COUNT(*) as ReviewCount,
    SUM(CASE WHEN AdminDecision = 'Approved' THEN 1 ELSE 0 END) as Approved,
    SUM(CASE WHEN AdminDecision = 'Rejected' THEN 1 ELSE 0 END) as Rejected
FROM PaymentAttempts 
WHERE AdminReviewedBy IS NOT NULL
GROUP BY AdminReviewedBy;

-- =====================================================
-- 6. PERFORMANCE CHECKS
-- =====================================================

-- Check for missing indexes
SELECT 
    'PaymentAttempts.OrderId Index' as IndexCheck,
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.indexes i
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.object_id = OBJECT_ID('PaymentAttempts') AND c.name = 'OrderId'
    ) THEN 'EXISTS' ELSE 'MISSING' END as Status

UNION ALL

SELECT 
    'PaymentAttempts.UserId Index' as IndexCheck,
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.indexes i
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.object_id = OBJECT_ID('PaymentAttempts') AND c.name = 'UserId'
    ) THEN 'EXISTS' ELSE 'MISSING' END as Status

UNION ALL

SELECT 
    'PaymentAttempts.Status Index' as IndexCheck,
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.indexes i
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.object_id = OBJECT_ID('PaymentAttempts') AND c.name = 'Status'
    ) THEN 'EXISTS' ELSE 'MISSING' END as Status;

-- =====================================================
-- 7. SUMMARY REPORT
-- =====================================================

SELECT 
    'PAYMENT SYSTEM REFACTORING VERIFICATION SUMMARY' as Report,
    GETDATE() as VerificationDate;

SELECT 
    'Total PaymentAttempts' as Metric,
    COUNT(*) as Value
FROM PaymentAttempts

UNION ALL

SELECT 
    'Manual Payment Methods' as Metric,
    COUNT(*) as Value
FROM PaymentAttempts 
WHERE Method = 2

UNION ALL

SELECT 
    'Pending Receipts' as Metric,
    COUNT(*) as Value
FROM PaymentAttempts 
WHERE Status = 1

UNION ALL

SELECT 
    'Awaiting Admin Approval' as Metric,
    COUNT(*) as Value
FROM PaymentAttempts 
WHERE Status = 3

UNION ALL

SELECT 
    'Completed Payments' as Metric,
    COUNT(*) as Value
FROM PaymentAttempts 
WHERE Status = 4

UNION ALL

SELECT 
    'Failed Payments' as Metric,
    COUNT(*) as Value
FROM PaymentAttempts 
WHERE Status = 5

UNION ALL

SELECT 
    'Total Course Enrollments' as Metric,
    COUNT(*) as Value
FROM CourseEnrollments

UNION ALL

SELECT 
    'Active Enrollments' as Metric,
    COUNT(*) as Value
FROM CourseEnrollments 
WHERE EnrollmentStatus = 0; -- Active

-- =====================================================
-- 8. ERROR DETECTION
-- =====================================================

-- Check for any data inconsistencies
SELECT 
    'ERROR CHECK' as Type,
    'PaymentAttempts with non-Manual method' as Issue,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE Method != 2

UNION ALL

SELECT 
    'ERROR CHECK' as Type,
    'PaymentAttempts with invalid status' as Issue,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE Status NOT IN (0, 1, 3, 4, 5)

UNION ALL

SELECT 
    'ERROR CHECK' as Type,
    'Approved payments without admin reviewer' as Issue,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE Status = 4 AND AdminReviewedBy IS NULL

UNION ALL

SELECT 
    'ERROR CHECK' as Type,
    'Receipts uploaded but status not awaiting approval' as Issue,
    COUNT(*) as Count
FROM PaymentAttempts 
WHERE ReceiptImageUrl IS NOT NULL AND Status != 3 AND Status != 4 AND Status != 5;

-- =====================================================
-- VERIFICATION COMPLETE
-- =====================================================

PRINT 'Payment System Refactoring Verification Complete';
PRINT 'Review the results above for any errors or inconsistencies';
PRINT 'All counts in ERROR CHECK section should be 0';
PRINT 'All PaymentAttempts should have Method = 2 (Manual)';
PRINT 'All Status values should be in (0,1,3,4,5)';