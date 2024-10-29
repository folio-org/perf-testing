-- FUNCTION: public.generate_inventory_data(integer)

-- DROP FUNCTION IF EXISTS public.generate_inventory_data(integer);

CREATE OR REPLACE FUNCTION public.generate_inventory_data(
	num_entries integer)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  instance_id UUID;
  srs_id UUID;
  instance_hrid TEXT;
  instance_title TEXT;
  holding_id UUID;
  holding_hrid TEXT;
  item_id UUID;
  item_barcode TEXT;
  item_hrid TEXT;
  creation_date TIMESTAMP;
  created_by_user UUID;
  instancestatusid UUID := NULL;
  instance_type_id UUID;
  mode_of_issuance_id UUID;
  holding_type_id UUID;
  callnumber_type_id UUID;
  material_type_id UUID;
  permanent_loan_type_id UUID;
  permanent_location_id UUID;
  complete_updated_date TIMESTAMP;
  snapshot_id UUID;
  sourceid UUID;
  itemNoteTypeId UUID;
  conflict_found BOOLEAN;
BEGIN
  FOR i IN 1..num_entries LOOP
    -- Generate new UUIDs
    instance_id := public.uuid_generate_v4();
    holding_id := public.uuid_generate_v4();
    item_id := public.uuid_generate_v4();
    srs_id := public.uuid_generate_v4();
    --getting user with admin parmissuion
     SELECT jsonb->>'userId' INTO created_by_user
    FROM [tenant]_mod_permissions.permissions_users
    WHERE jsonb -> 'permissions' @> '"folio_admin"' 
    LIMIT 1;
--getting instance_type_id
    SELECT id into instance_type_id
	  FROM [tenant]_mod_inventory_storage.instance_type limit 1;
--getting mode_of_issuance_id
    SELECT id into mode_of_issuance_id
	  FROM [tenant]_mod_inventory_storage.mode_of_issuance limit 1;
--getting holding_type_id
    SELECT id into holding_type_id
	  FROM [tenant]_mod_inventory_storage.holdings_type limit 1;
--getting callnumber_type_id
     SELECT id into callnumber_type_id
	   FROM [tenant]_mod_inventory_storage.call_number_type limit 1;
--getting material_type_id
      SELECT id into material_type_id
    	FROM [tenant]_mod_inventory_storage.material_type limit 1;
--getting permanent_loan_type_id
      SELECT id into permanent_loan_type_id
	    FROM [tenant]_mod_inventory_storage.loan_type limit 1;
--getting permanent_location_id
      SELECT id into permanent_location_id
     	FROM [tenant]_mod_inventory_storage.location limit 1;

--getting snapshot_id
      SELECT id into snapshot_id
      	FROM [tenant]_mod_source_record_storage.snapshots_lb  limit 1;
        
--getting sourceid
      SELECT id into sourceid
      	FROM  [tenant]_mod_inventory_storage.holdings_records_source 
        where jsonb->>'name' ='FOLIO'  limit 1;

--getting itemNoteTypeId
      SELECT id into itemNoteTypeId
      	FROM [tenant]_mod_inventory_storage.instance_note_type limit 1;


    -- Generate unique HRIDs
    LOOP
      instance_hrid := 'cenin' || LPAD((FLOOR(RANDOM() * 10000000000))::TEXT, 11, '0');
      SELECT EXISTS (
        SELECT 1 FROM [tenant]_mod_inventory_storage.instance 
        WHERE LOWER([tenant]_mod_inventory_storage.f_unaccent(jsonb ->> 'hrid'::text)) = LOWER(instance_hrid)
      ) INTO conflict_found;
      EXIT WHEN NOT conflict_found;
    END LOOP;

    LOOP
      holding_hrid := 'cenho' || LPAD((FLOOR(RANDOM() * 10000000000))::TEXT, 11, '0');
      SELECT EXISTS (
        SELECT 1 FROM [tenant]_mod_inventory_storage.holdings_record 
        WHERE LOWER([tenant]_mod_inventory_storage.f_unaccent(jsonb ->> 'hrid'::text)) = LOWER(holding_hrid)
      ) INTO conflict_found;
      EXIT WHEN NOT conflict_found;
    END LOOP;

    LOOP
      item_hrid := 'cenit' || LPAD((FLOOR(RANDOM() * 10000000000))::TEXT, 11, '0');
      SELECT EXISTS (
        SELECT 1 FROM [tenant]_mod_inventory_storage.item 
        WHERE LOWER([tenant]_mod_inventory_storage.f_unaccent(jsonb ->> 'hrid'::text)) = LOWER(item_hrid)
      ) INTO conflict_found;
      EXIT WHEN NOT conflict_found;
    END LOOP;

    -- Generate random barcode
   LOOP
      item_barcode := LPAD((FLOOR(RANDOM() * 1000000000000))::TEXT, 12, '0');
      SELECT EXISTS (
        SELECT 1 FROM [tenant]_mod_inventory_storage.item 
        WHERE LOWER(jsonb ->> 'barcode'::text) = LOWER(item_barcode)
      ) INTO conflict_found;
      EXIT WHEN NOT conflict_found;
    END LOOP;
    
    -- Create unique titles
    instance_title := 'PerfTesting Instance ' || i;
    
    -- Get current timestamp
    creation_date := NOW();
    complete_updated_date := NOW();
    
    -- Insert into instance table
    INSERT INTO [tenant]_mod_inventory_storage.instance (
      id, jsonb, creation_date, created_by, instancestatusid, modeofissuanceid, instancetypeid, complete_updated_date
    ) VALUES (
      instance_id,
      jsonb_build_object(
        'id', instance_id,
        'hrid', instance_hrid,
        'tags', jsonb_build_object('tagList', jsonb_build_array()),
        'notes', jsonb_build_array(),
        'title', instance_title,
        'series', jsonb_build_array(),
        'source', 'FOLIO',
        '_version', 1,
        'editions', jsonb_build_array(),
        'metadata', jsonb_build_object(
          'createdDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'updatedDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'createdByUserId', created_by_user,
          'updatedByUserId', created_by_user
        ),
        'subjects', jsonb_build_array(),
        'languages', jsonb_build_array(),
        'indexTitle', '123',
        'identifiers', jsonb_build_array(),
        'publication', jsonb_build_array(),
        'contributors', jsonb_build_array(),
        'catalogedDate', to_char(creation_date, 'YYYY-MM-DD'),
        'staffSuppress', false,
        'instanceTypeId', instance_type_id,
        'previouslyHeld', false,
        'classifications', jsonb_build_array(),
        'instanceFormats', jsonb_build_array(),
        'electronicAccess', jsonb_build_array(),
        'holdingsRecords2', jsonb_build_array(),
        'modeOfIssuanceId', mode_of_issuance_id,
        'publicationRange', jsonb_build_array(),
        'alternativeTitles', jsonb_build_array(),
        'discoverySuppress', false,
        'instanceFormatIds', jsonb_build_array(),
        'statusUpdatedDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
        'statisticalCodeIds', jsonb_build_array(),
        'administrativeNotes', jsonb_build_array(),
        'physicalDescriptions', jsonb_build_array(),
        'publicationFrequency', jsonb_build_array(),
        'natureOfContentTermIds', jsonb_build_array()
      ),
      creation_date,
      created_by_user,
      instancestatusid,
      mode_of_issuance_id,
      instance_type_id,
      complete_updated_date
    );

    --insert into records_lb table
    INSERT INTO [tenant]_mod_source_record_storage.records_lb (
      id, snapshot_id, matched_id, generation, record_type, external_id, state, leader_record_status, "order", suppress_discovery, created_by_user_id, created_date, updated_by_user_id, updated_date, external_hrid
    ) VALUES (
      srs_id, 
      snapshot_id, 
      srs_id, 
      '0', 
      'MARC_BIB', 
      instance_id, 
      'ACTUAL', 
      'c', 
      0, 
      false, 
      created_by_user, 
      creation_date, 
      created_by_user,
      creation_date, 
      instance_hrid 
    );

    -- Insert into raw_records_lb table
    INSERT INTO [tenant]_mod_source_record_storage.raw_records_lb (
      id, content
    ) VALUES (
      srs_id,
      jsonb_build_object(
        'leader', '04730cam a2200601 i 4500',
        'fields', jsonb_build_array(
          jsonb_build_object('001', instance_hrid),
          jsonb_build_object('005', to_char(creation_date, 'YYYYMMDDHH24MISS')),
          jsonb_build_object('008', '220422t20232023ilu      b    001 0 eng  '),
          jsonb_build_object(
            '010', jsonb_build_object(
              'ind1', ' ',
              'ind2', ' ',
              'subfields', jsonb_build_array(
                jsonb_build_object('a', '2022018908')
              )
            )
          ),
          -- Add more fields as needed
          jsonb_build_object(
            '999', jsonb_build_object(
              'ind1', 'f',
              'ind2', 'f',
              'subfields', jsonb_build_array(
                jsonb_build_object('i', instance_id),
                jsonb_build_object('s', srs_id)
              )
            )
          )
        )
      )
    );

    --insert into markrecords
    INSERT INTO [tenant]_mod_source_record_storage.marc_records_lb (
      id, content
    ) VALUES (
      srs_id,
      jsonb_build_object(
        'leader', '04730cam a2200601 i 4500',
        'fields', jsonb_build_array(
          jsonb_build_object('001', instance_hrid),
          jsonb_build_object('005', to_char(creation_date, 'YYYYMMDDHH24MISS')),
          jsonb_build_object('008', '220422t20232023ilu      b    001 0 eng  '),
          jsonb_build_object(
            '010', jsonb_build_object(
              'ind1', ' ',
              'ind2', ' ',
              'subfields', jsonb_build_array(
                jsonb_build_object('a', '2022018908')
              )
            )
          ),
          -- Add more fields as needed
          jsonb_build_object(
            '999', jsonb_build_object(
              'ind1', 'f',
              'ind2', 'f',
              'subfields', jsonb_build_array(
                jsonb_build_object('i', instance_id),
                jsonb_build_object('s', srs_id)
              )
            )
          )
        )
      )
    );

    -- Insert into holdings record table
    INSERT INTO [tenant]_mod_inventory_storage.holdings_record (
      id, jsonb, creation_date, created_by, instanceid, permanentlocationid, temporarylocationid, effectivelocationid, holdingstypeid, callnumbertypeid, illpolicyid, sourceid
    ) VALUES (
      holding_id,
      jsonb_build_object(
        'id', holding_id,
        'hrid', holding_hrid,
        'notes', jsonb_build_array(),
        '_version', 1,
        'metadata', jsonb_build_object(
          'createdDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'updatedDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'createdByUserId', created_by_user,
          'updatedByUserId', created_by_user
        ),
        'sourceId', sourceid,
        'formerIds', jsonb_build_array(),
        'callNumber', 'BR140 .J6',
        'instanceId', instance_id,
        'holdingsTypeId', holding_type_id,
        'callNumberTypeId', callnumber_type_id,
        'electronicAccess', jsonb_build_array(),
        'holdingsStatements', jsonb_build_array(),
        'statisticalCodeIds', jsonb_build_array(),
        'administrativeNotes', jsonb_build_array(),
        'effectiveLocationId', permanent_location_id,
        'permanentLocationId', permanent_location_id,
        'holdingsStatementsForIndexes', jsonb_build_array(),
        'holdingsStatementsForSupplements', jsonb_build_array()
      ),
      creation_date,
      created_by_user,
      instance_id,
      permanent_location_id,
      NULL,
      permanent_location_id,
      holding_type_id,
      callnumber_type_id,
      NULL,
      sourceid
    );

    -- Insert into item table
    INSERT INTO [tenant]_mod_inventory_storage.item (
      id, jsonb, creation_date, created_by, holdingsrecordid, permanentloantypeid, temporaryloantypeid, materialtypeid, permanentlocationid, temporarylocationid, effectivelocationid
    ) VALUES (
      item_id,
      jsonb_build_object(
        'id', item_id,
        'hrid', item_hrid,
        'tags', jsonb_build_object('tagList', jsonb_build_array()),
        'notes', jsonb_build_array(
          jsonb_build_object(
            'note', 'Smith Family Foundation',
            'staffOnly', true,
            'itemNoteTypeId', itemNoteTypeId
          )
        ),
        'status', jsonb_build_object(
          'date', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'name', 'Available'
        ),
        'barcode', item_barcode,
        '_version', 1,
        'metadata', jsonb_build_object(
          'createdDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'updatedDate', to_char(creation_date, 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'),
          'createdByUserId', created_by_user,
          'updatedByUserId', created_by_user
        ),
        'formerIds', jsonb_build_array(),
        'yearCaption', jsonb_build_array(),
        'materialTypeId', material_type_id,
        'circulationNotes', jsonb_build_array(),
        'electronicAccess', jsonb_build_array(),
        'holdingsRecordId', holding_id,
        'statisticalCodeIds', jsonb_build_array(),
        'administrativeNotes', jsonb_build_array(),
        'effectiveLocationId', permanent_location_id,
        'permanentLoanTypeId', permanent_loan_type_id,
        'effectiveShelvingOrder', 'BR 3140 J6',
        'effectiveCallNumberComponents', jsonb_build_object(
          'typeId', callnumber_type_id,
          'callNumber', 'BR140 .J6'
        )
      ),
      creation_date,
      created_by_user,
      holding_id,
      permanent_loan_type_id,
      NULL,
      material_type_id,
      permanent_location_id,
      NULL,
      permanent_location_id
    );

  END LOOP;
END;
$BODY$;

ALTER FUNCTION public.generate_inventory_data(integer)
    OWNER TO folio;


SELECT public.generate_inventory_data(1);
