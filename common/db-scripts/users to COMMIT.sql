CREATE OR REPLACE FUNCTION populate_users_and_permissions(num_records INTEGER) 
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
    user_id UUID;
    permission_id UUID;
    creation_time TIMESTAMP := NOW();
    created_by_user UUID; 
    patrongroup UUID;
    random_barcode TEXT;
    barcode_exists BOOLEAN;
    i INTEGER;
    
BEGIN
    -- Fetch the 'created_by_user' (admin user ID) based on "folio_admin" permission
    SELECT jsonb->>'userId' INTO created_by_user
    FROM [tenant]_mod_permissions.permissions_users
    WHERE jsonb -> 'permissions' @> '"folio_admin"' 
    LIMIT 1;

    -- Fetch the 'patronGroup' of the admin user
    SELECT jsonb->>'patronGroup' INTO patrongroup
    FROM [tenant]_mod_users.users 
    WHERE id = created_by_user
    LIMIT 1;

    -- Loop to create the specified number of records
    FOR i IN 1..num_records LOOP
        -- Generate a unique user ID
        user_id := uuid_generate_v4();

        -- Generate a random barcode and ensure it is unique
        LOOP
            random_barcode := LPAD(floor(random() * 1000000)::text, 6, '0');

            -- Check if the barcode already exists in the database
            SELECT EXISTS (
                SELECT 1 
                FROM [tenant]_mod_users.users 
                WHERE jsonb ->> 'barcode' = random_barcode
            ) INTO barcode_exists;

            -- Exit the loop if the barcode is unique
            EXIT WHEN NOT barcode_exists;
        END LOOP;

        -- Insert into [tenant]_mod_users.users
        INSERT INTO [tenant]_mod_users.users(id, jsonb, creation_date, created_by, patrongroup)
        VALUES (
            user_id,
            jsonb_build_object(
                'id', user_id,
                'type', 'patron',
                'active', TRUE,
                'barcode', random_barcode,
                'metadata', jsonb_build_object(
                    'createdDate', to_jsonb(creation_time),
                    'updatedDate', to_jsonb(creation_time),
                    'createdByUserId', created_by_user, 
                    'updatedByUserId', created_by_user   
                ),
                'personal', jsonb_build_object(
                    'email', 'some' || i::text || '@ebsco.com',
                    'lastName', 'LastName' || i::text,
                    'addresses', jsonb_build_array(),
                    'firstName', 'FirstName' || i::text,
                    'preferredContactTypeId', '002'
                ),
                'proxyFor', jsonb_build_array(),
                'createdDate', to_jsonb(creation_time),
                'departments', jsonb_build_array(),
                'patronGroup', patrongroup,
                'updatedDate', to_jsonb(creation_time),
                'preferredEmailCommunication', jsonb_build_array()
            ),
            creation_time,
            created_by_user, 
            patrongroup
        );

        -- Generate a unique permission ID
        permission_id := uuid_generate_v4();

        -- Insert into [tenant]mod_permissions.permissions_users
        INSERT INTO [tenant]_mod_permissions.permissions_users(id, jsonb, creation_date, created_by)
        VALUES (
            permission_id,
            jsonb_build_object(
                'id', permission_id,
                'userId', user_id,
                'metadata', jsonb_build_object(
                    'createdDate', to_jsonb(creation_time),
                    'updatedDate', to_jsonb(creation_time),
                    'createdByUserId', created_by_user,  
                    'updatedByUserId', created_by_user   
                ),
                'permissions', jsonb_build_array()
            ),
            creation_time,
            created_by_user 
        );

    END LOOP;
END;
$$;


SELECT populate_users_and_permissions(1);
