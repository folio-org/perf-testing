#!/bin/bash -e

if [[ $# -lt 2 ]]; then
   echo "Usage: $0 <db config> <TENANT> [--clear-loan-audit]";
   echo "       $0 psql.conf diku";

   exit 1;
fi

export TENANT=${1}
export orderesNum=${2}

export PGDATABASE=${3}
export PGUSER=${4}
export PGPASSWORD=${5}
export PGHOST=${6}
export PGPORT=${7}

echo "================================================="
echo "PGUSER: $PGUSER"
echo "PGPASSWORD: $PGPASSWORD"
echo "PGDATABASE: $PGDATABASE"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
echo "TENANT: $TENANT"
echo "=================================================="

# ==================================================
#  re-populate the database
# ==================================================



psql -a -c "SELECT count(*) FROM ${TENANT}_mod_orders_storage.purchase_order "

while IFS=, read -r organizationID AccNum
do
psql -a -c "CREATE OR REPLACE FUNCTION public.generate_data_for_edifact_export(organizations_amount integer,
                                                                   orders_per_vendor integer,
                                                                   polines_per_order integer) RETURNS VOID as
\$\$

DECLARE
    -- !!! SET DEFAULT TENANT NAME !!!
    orgName   text DEFAULT 'perf_test_vendor';
    orgCode   TEXT default 'PERF_TEST_ORG';
    vendor_id TEXT;
BEGIN
    for org_counter in 1..organizations_amount
        loop
/*            INSERT INTO ${TENANT}_mod_organizations_storage.organizations (id, jsonb)
            VALUES (public.uuid_generate_v4(),
                    jsonb_build_object('code', concat(orgCode, org_counter),
                                       'erpCode', '12345',
                                       'isVendor', true,
                                       'name', concat(orgName, org_counter),
                                       'status', 'Active',
                                       'metadata', jsonb_build_object(
                                               'createdDate', '2018-07-19T00:00:00.000+0000',
                                               'createdByUserId', '28d1057c-d137-11e8-a8d5-f2801f1b9fd1',
                                               'updatedDate', '2018-07-19T00:00:00.000+0000',
                                               'updatedByUserId', '28d1057c-d137-11e8-a8d5-f2801f1b9fd1'
                                           )
                        ))
            RETURNING id INTO vendor_id;*/

            PERFORM public.generate_orders(orders_per_vendor, polines_per_order, '${organizationID}');-------------------------------
        end loop;
END
\$\$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.generate_orders(orders_per_vendor integer, polines_per_order integer, vendor_id text) RETURNS VOID as
\$\$
DECLARE
    order_id    text;
    newPoNumber integer;
BEGIN
    for order_counter in 1..orders_per_vendor
        loop
            SELECT nextval('${TENANT}_mod_orders_storage.po_number') INTO newPoNumber;
            --
            INSERT INTO ${TENANT}_mod_orders_storage.purchase_order (id, jsonb)
            VALUES (public.uuid_generate_v4(),
                    jsonb_build_object('id', public.uuid_generate_v4(),
                                       'reEncumber', true,
                                       'workflowStatus', 'Open',
                                       'poNumber', newPoNumber,
                                       'vendor', vendor_id,
                                       'orderType', 'One-Time',
                                       'metadata', jsonb_build_object(
                                               'createdDate', '2018-07-19T00:00:00.000+0000',
                                               'createdByUserId', '28d1057c-d137-11e8-a8d5-f2801f1b9fd1',
                                               'updatedDate', '2018-07-19T00:00:00.000+0000',
                                               'updatedByUserId', '28d1057c-d137-11e8-a8d5-f2801f1b9fd1'
                                           )
                        ))


            RETURNING id INTO order_id;
            PERFORM public.generate_polines(order_id, polines_per_order, newPoNumber);
        end loop;
END
\$\$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.generate_polines(order_id text, polines_per_order integer, ponumber integer) RETURNS VOID as
\$\$
DECLARE
    polineNumber text;
BEGIN
    for line_counter in 1..polines_per_order
        loop
            INSERT INTO ${TENANT}_mod_orders_storage.po_line (id, jsonb)
            VALUES (public.uuid_generate_v4(),
                       -- add other fields to increase processing complexity
                    jsonb_build_object('id', public.uuid_generate_v4(),
                                       'acquisitionMethod', 'df26d81b-9d63-4ff8-bf41-49bf75cfa70e',
                                       'rush', false,
                                       'cost', json_build_object(
                                               'currency', 'USD',
                                               'discountType', 'percentage',
                                               'listUnitPrice', 1,
                                               'quantityPhysical', 1,
                                               'poLineEstimatedPrice', 1
                                           ),
                                       'alerts', json_build_array(),
                                       'source', 'User',
                                       'physical', jsonb_build_object('createInventory', 'None'),
                                       'isPackage', false,
                                       'orderFormat', 'Physical Resource',
                                       'vendorDetail', jsonb_build_object('vendorAccount', '${AccNum}'),---------------------------------
                                       'titleOrPackage', 'ABA Journal',
                                       'automaticExport', true,
                                       'publicationDate', '1915-1983',
                                       'purchaseOrderId', order_id,
                                       'poLineNumber', concat(ponumber, '-', line_counter),
                                       'claims', json_build_array(),
                                       'metadata', jsonb_build_object(
                                               'createdDate', '2018-07-19T00:00:00.000+0000',
                                               'createdByUserId', '28d1057c-d137-11e8-a8d5-f2801f1b9fd1',
                                               'updatedDate', '2018-07-19T00:00:00.000+0000',
                                               'updatedByUserId', '28d1057c-d137-11e8-a8d5-f2801f1b9fd1'
                                           )
                        ));
        end loop;
END
\$\$ LANGUAGE plpgsql;


-- CREATE sample data
-- 1 - amount of organizations to be created
-- 2 - amount of orders per organization
-- 3 - amount of polines per order
select public.generate_data_for_edifact_export(1, ${orderesNum}, 1);


--check
--SELECT count() FROM ${TENANT}_mod_organizations_storage.organizations WHERE jsonb ->> 'code' LIKE 'PERF_TEST_ORG%';
--SELECT count(*) FROM ${TENANT}_mod_orders_storage.purchase_order;
SELECT count(*)
FROM ${TENANT}_mod_orders_storage.po_line;"





    echo "$organizationID and $AccNum"
done < organizations.csv

psql -a -c "SELECT count(*) FROM ${TENANT}_mod_orders_storage.purchase_order "

exit 0;