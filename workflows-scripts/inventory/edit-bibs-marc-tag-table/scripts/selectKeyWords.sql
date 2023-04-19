SELECT substring(((fs09000000_mod_inventory_storage.instance.jsonb)->'title')::TEXT from 2 for 4),ARRAY_AGG(fs09000000_mod_inventory_storage.instance.id)
FROM fs09000000_mod_inventory_storage.instance
INNER JOIN fs09000000_mod_inventory.records_instances
ON fs09000000_mod_inventory_storage.instance.id = fs09000000_mod_inventory.records_instances.instance_id
INNER JOIN fs09000000_mod_source_record_storage.raw_records_lb
ON fs09000000_mod_inventory.records_instances.record_id = fs09000000_mod_source_record_storage.raw_records_lb.id
group by substring(((fs09000000_mod_inventory_storage.instance.jsonb)->'title')::TEXT from 2 for 4)
having count(1) > 3 and count(1) < 10;