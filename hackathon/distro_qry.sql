SELECT f.quantity, f.block_number, tx_subtype
-- SELET SUM(JSON_LENGTH(tx_detail->>"$.quantities"))
FROM assets.fact_gc_transactions f
WHERE f.block_number = 4052634;

-- drop table distros
CREATE TABLE distros AS
SELECT f.quantity, f.tx_in_block, f.tran_key, f.block_number, tx_subtype
	-- , raw.tx_detail, raw.tx_ccresponse
    , JSON_LENGTH(tx_detail->>"$.quantities") AS 'Operators'
    , LEFT(f.tx_subtype, 35) 'distro'
    , CAST(CONCAT('20', RIGHT(LEFT(f.tx_subtype, 35), 8)) AS DATE) 'distro_date'
    , jt.*
FROM assets.fact_gc_transactions f
INNER JOIN gc_raw_tmp raw ON raw.tran_key = f.tran_key
JOIN json_table(
	raw.tx_detail, '$.quantities[*]'
    COLUMNS(user VARCHAR(50) path '$.user'
			,quantities decimal(26,8) path '$.quantity')
    ) jt
 WHERE LEFT(f.tx_subtype, 35) = 'founders-node-distribution_23-12-21'
;
CREATE INDEX ix_distros_date ON distros(distro_date);

-- SELECT f.quantity, raw.tx_detail, raw.tx_ccresponse FROM assets.fact_gc_transactions f WHERE LEFT(f.tx_subtype, 35) = 'founders-node-distribution_23-21-04'



SELECT * FROM distros LIMIT 100;

CREATE VIEW node_distro AS
SELECT *, CAST(quantities / single AS UNSIGNED) nodes
FROM(
	SELECT block_number, distro_date, user, quantities, MIN(quantities) OVER (PARTITION BY distro_date) 'single'
	FROM distros
	ORDER BY distro_date
)sq;

select count(1), distro_date from distros group by distro_date;
delete from distros where distro_date = '2023-12-05';