- Outward FT Contracts booked on a date
-- Detail
SELECT * FROM fttb_outwrd_extract_status es, cstb_contract cc
WHERE cc.contract_ref_no = es.contract_ref_no
and cc.product_code IN ('OCTS','OCTM','ORTS','ORTM','IDCT')
and cc.book_date = '&Book_Date';
--- Count
SELECT count(*) FROM fttb_outwrd_extract_status es, cstb_contract cc
WHERE cc.contract_ref_no = es.contract_ref_no
and cc.product_code IN ('OCTS','OCTM','ORTS','ORTM','IDCT')
and cc.book_date = '&Book_Date';
-- Outward FT Contracts booked on a date
-- Detail
SELECT * FROM fttb_outwrd_extract_status es, cstb_contract cc
WHERE cc.contract_ref_no = es.contract_ref_no
and cc.product_code IN ('OCTS','OCTM','ORTS','ORTM','IDCT')
and cc.book_date = '&Book_Date' FOR UPDATE NOWAIT; 
--- Count
SELECT es.processed, count(*) FROM fttb_outwrd_extract_status es, cstb_contract cc
WHERE cc.contract_ref_no = es.contract_ref_no
and cc.product_code IN ('OCTS','OCTM','ORTS','ORTM','IDCT')
and cc.book_date = '&Book_Date'
group by es.processed;

SELECT * FROM fttb_outwrd_extract_status
WHERE contract_ref_no in
(
SELECT cc.contract_ref_no 
FROM fttb_outwrd_extract_status es, cstb_contract cc
WHERE cc.contract_ref_no = es.contract_ref_no
and cc.product_code IN ('OCTS','OCTM','ORTS','ORTM','IDCT')
and cc.book_date = '&Book_Date'
) FOR UPDATE NOWAIT;  
