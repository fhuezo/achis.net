SELECT *
FROM assets.fact_gc_transactions t
INNER JOIN dim_tx_type dtt ON dtt.tx_type_key = t.tx_type_key
	AND tx_type = 'BridgeTokenOut'
LIMIT 100;


select * from dim_tx_type limit 100;