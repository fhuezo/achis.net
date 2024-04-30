-- truncate table gc_raw_tmp
INSERT INTO gc_raw_tmp
(blocknumber, tx_in_block, tran_key, tx_detail, tx_ccresponse)
SELECT ft.block_number, ft.tx_in_block, ft.tran_key, CAST(CAST(UNCOMPRESS(tx_detail) AS char) AS JSON), CAST(CAST(UNCOMPRESS(tx_ccresponse) AS char) AS JSON)
FROM assets.fact_gc_transactions ft
INNER JOIN gc_raw_data raw
	ON raw.blocknumber = ft.block_number
    AND raw.tx_in_block = ft.tx_in_block
WHERE left(tx_subtype, 26) = 'founders-node-distribution';

select * from gc_raw_tmp limit 1000;

SELECT * FROM assets.fact_gc_transactions LIMIT 100;
SELECT * FROM assets.fact_gc_transactions where tx_subtype like '%chunk%' limit 100;
SELECT * FROM assets.fact_gc_transactions where left(tx_subtype, 35) = 'founders-node-distribution_23-12-05';

select 
	max(length(CAST(UNCOMPRESS(tx_detail) AS char))) -- , UNCOMPRESS(tx_ccresponse)
from assets.gc_raw_data limit 100;

select 
	CAST(CAST(UNCOMPRESS(tx_detail) AS json) AS CHAR(1000)) -- , UNCOMPRESS(tx_ccresponse)
from assets.gc_raw_data limit 100;

SELECT distinct tx_subtype FROM assets.fact_gc_transactions limit 100;
select * from assets.dim_tx_type;
-- drop table gc_raw_tmp
CREATE TABLE gc_raw_tmp (
  blocknumber bigint,
  tx_in_block int,
  tx_detail json,
  tx_ccresponse json,
  tran_key bigint
);

create index ix_locktran_raw ON gc_raw_tmp(blocknumber, tx_in_block);
create index ix_locktran_tran_raw ON gc_raw_tmp(tran_key);

