SELECT substring((({tenant}_mod_inventory_storage.instance.jsonb)->'title')::TEXT from 2 for 4),LEAST((count(1)-2),5)
	FROM {tenant}_mod_inventory_storage.instance
	INNER JOIN {tenant}_mod_inventory.records_instances
	ON {tenant}_mod_inventory_storage.instance.id = {tenant}_mod_inventory.records_instances.instance_id
	INNER JOIN {tenant}_mod_source_record_storage.raw_records_lb
	ON {tenant}_mod_inventory.records_instances.record_id = {tenant}_mod_source_record_storage.raw_records_lb.id
	group by substring((({tenant}_mod_inventory_storage.instance.jsonb)->'title')::TEXT from 2 for 4)
	having count(1) > 3 and count(1) < 10;