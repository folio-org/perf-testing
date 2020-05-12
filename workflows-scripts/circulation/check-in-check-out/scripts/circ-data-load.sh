# This script needs to be supplied a psql.conf file, which contains the endpoint and credentials of the database.
# This script needs to be run in the same directory as the loans.tsv, requests.tsv, and patron_action_sessions.tsv"
# Example usage: $ ./circ-data-load.sh psql.conf fs08000010 

#!/bin/bash -e

if [[ $# -lt 2 ]]; then
   echo "Usage: $0 <db config> <TENANT> [--clear-loan-audit]";
   echo "       $0 psql.conf diku";
   
   exit 1;
fi

DBCONF=${1}
export TENANT=${2}

export PGDATABASE=`cat $DBCONF | jq '.database' | cut -d\" -f2`
export PGUSER=`cat $DBCONF | jq '.username' | cut -d\" -f2`
export PGPASSWORD=`cat $DBCONF | jq '.password' | cut -d\" -f2`
export PGHOST=`cat $DBCONF | jq '.host' | cut -d\" -f2`
export PGPORT=`cat $DBCONF | jq '.port' | cut -d\" -f2`

LOANS="loans.tsv"
REQUESTS="requests.tsv"
# AUDIT_LOANS="audit_loans.tsv"
PATRON_ACTION_SESSION="patron_action_sessions.tsv"

echo "================================================="
echo "PGUSER: $PGUSER"
echo "PGPASSWORD: $PGPASSWORD"
echo "PGDATABASE: $PGDATABASE"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
echo "TENANT: $TENANT"
echo ""
echo "LOANS: $LOANS"
echo "REQUESTS: $REQUESTS"
echo "AUDIT_LOANS: $AUDIT_LOANS"
echo "PATRON_ACTION_SESSION: $PATRON_ACTION_SESSION"
echo "=================================================="

# ==================================================
#  re-populate the database
# ==================================================

test "null" != "${LOANS}" && psql -a -c "\copy ${TENANT}_mod_circulation_storage.loan(id, jsonb) FROM '${LOANS}' DELIMITER E'\t'"
test "null" != "${REQUESTS}" && psql -a -c "\copy ${TENANT}_mod_circulation_storage.request(id, jsonb) FROM '${REQUESTS}' DELIMITER E'\t'"
# test "null" != "${AUDIT_LOANS}" && psql -a -c "\copy ${TENANT}_mod_circulation_storage.audit_loan(id, jsonb) FROM '${AUDIT_LOANS}' DELIMITER E'\t'"
test "null" != "${PATRON_ACTION_SESSION}" && psql -a -c "\copy ${TENANT}_mod_circulation_storage.patron_action_session(id, jsonb) FROM '${PATRON_ACTION_SESSION}' DELIMITER E'\t'"

# Update the Items and set their status to "checked out"
psql -a -c "UPDATE fs08000010_mod_inventory_storage.item SET jsonb = jsonb_set(jsonb, '{status, name}', '\"Checked out\"') where id IN ('cc2f1b28-5a4d-4609-bbb3-e1d9ce90da1d','bf976e3e-9dbb-48c3-9ba4-47f40cf0a27f','3c785504-7078-4a96-8d6a-e2a47776715c','bf1f62f1-f0e6-4f5a-bf9c-915233610c64','2446deb1-25ef-4a27-a052-5ce0c8193e42','2b6e5bc3-707e-4eb5-809f-e45084651de4','3eaf8f17-813f-4be2-84cd-72146cd67c9b','f5e10b26-71d7-4a9c-bad8-3e6b2598c390','aadf5f60-45a8-4f66-a0e9-d33f6072e24c','e94afb71-4959-43e3-8753-93215d2b1c81','3c3f63cc-fad1-4760-919a-6a8543b976ff','1979cae8-3af6-4895-b272-6b0f9fa91e88','2a20f1af-77a8-47d3-8a07-c2617015aa33','d14ba580-6782-435a-9a9d-486cf4bb5f12','ce5edca8-db84-4f53-9ba1-fae97a7ae097','3018a66a-3f0e-447e-978a-49b5896e851b','6fb20e4a-693e-4564-b41b-78830c0a8a9d','3fb9c7a9-6350-4db0-ba23-3855a1b1dffc','f9215b17-5a9f-4208-b7e7-debc4abfc8aa','da58827d-f5a2-4414-ac8b-485fe07e4343','39a404d1-901a-403e-bb69-a8aaa514eb94','c9bcad5d-faae-468e-9a28-2d9b5d6f4759','86ca8d30-8541-407d-a70c-8bf113627bcb','5e567d26-ec2d-47f4-a9ed-839c6c339c6b','7ba8ccda-b6e2-493b-8b6a-33db36bff68a','86d9192b-e2cc-42e1-baee-70522240d22e','4fa8b043-e860-4e42-9805-375e1739c9b3','10768b90-72c3-4bd5-806a-acd2d56b13b2','3009ea57-9940-49c5-a6e4-9cf8ef85dc10','491d9037-50ab-45eb-9b4e-75baa773ae99','8b2a2ae3-a78d-42c2-be0d-76e05974def7','5cb95965-c896-402c-bedc-ae1566d200f9','e3fe3998-a734-4e34-b0a4-3936be0b258b','8124b03b-93a2-425e-bd03-bba931e47d9e','afbbc91f-28e5-44ce-9f76-9df71ff1f873','559d4eb7-0067-44eb-801a-4f14ae37025f','58e6de1f-8e53-4a4b-8c48-79aca12ef3e4','bdb4d373-4a47-4545-888a-fdd0cc876707','2330a0b9-cd6a-4917-a966-49f332fda262','bf1a5a4c-0f5e-4ee8-b313-e337f9cf7ab4','f410a18c-89ca-4174-b58c-71c6a8a92c0c','c69d725b-ca8e-402c-9d0d-4e788a68d56f','3ea564ae-202a-4d98-83d1-0eb422ee0f10','ee2cc3d8-5c97-4364-b201-f632cfc8b5a1','cd793661-74a4-40d7-aa06-f58d6ac193f5','6937c2fe-6aaf-4744-b3d1-b58c44399f0e','1a155d6f-13ed-42cf-9f99-42fa39bcf455','ed0d3359-8c98-43de-89f7-fe4693d5de6d','44fd725d-7754-42a0-bf4c-f66c29f948df','239f48a0-17ac-46eb-928e-8e47e3193076','de1843f8-2bcb-4223-baad-79502c7a99c5','31caab09-cc4c-4ef6-9dd7-1fdccaa1dfbc','84f8ea34-8094-40a6-83da-3d9729e4c489','d2bd2971-f416-48eb-a0a0-77b23fbb3e69','75967de1-e733-46ff-bc51-be0233ee3ed2','173854ed-980f-487e-97a5-4fa545d4e3c1','5ba1d9a6-6930-4704-baaf-34932fb5583e','cbc40633-108f-4009-8e92-3a5f72462873','1069cd3d-1127-4487-9ed8-e072bfb5e20b','30ed08e8-5130-49c3-9370-538ece6c337d','a1b7fb76-f83f-4e74-b54e-05f7dd09133e','7fcf4452-1b32-4e95-8d1e-0a94f4eac2cc','3948116e-88f6-4223-9a91-058b7dc24132','20f44660-f8b9-42ab-9208-a17f39d21a0a','9745948a-e82b-441e-aa61-b0193c23e40a','7ca67b4d-bcbd-49f1-bb5b-adfd37360144','46b88cfe-3926-444d-b667-c63c0a8377d7','e9d7cd1e-c5be-48d1-b663-df82c4e24931','fc91343c-8d7e-465a-afcf-9c1f319a6b74','aeb030ee-3a26-46d1-9f43-069716acd69e','04306297-becd-4a66-8495-d67ed20cc217','df4f2924-d526-4a43-b97a-31f95bced97e','52e4ecb4-a7a4-4a51-ad6e-b6fa67fcb959','bbd14b1c-681f-4153-b9a1-c6b561dcb4c3','56cb0c2d-5bb9-49a9-958b-1a05ec23d6f4','4b2044d0-592d-4ea3-8d24-8a9fea9f0ed5','1c97442f-8c7e-49ac-a850-ccaaace8d53a','8d4c0338-cb1a-4f88-96d1-0d6039b8c3a4','28349d3c-eb27-43a9-8f38-08e426576717','5304c1ff-1344-4278-b72c-1226161160b0','836591d7-f140-4f66-bf1a-80b5cab5cd5d','16ffd492-be90-4544-877f-613c3ddf07e6','b2c09c85-daba-4fbd-90d2-583cbb140b76','a697e690-dc55-4966-a647-c578d0e63801','d2310f1f-499f-4802-b40a-de1c56fe9767','4786b140-550e-4fa0-bb80-1637e6bd30bb','9642d84f-f053-4ad3-836c-c96f67b2ebed','f723d734-9450-42ee-a028-1dc4c920ab28','4a7e098f-6bb8-4b38-86ae-6d2029dcae6a','90591bed-4b06-4816-8e06-9bacb0bd7b0c','2dfae3c4-194a-4c4b-8e2c-22b2cbe950d2','25d6675f-d6fe-4ca9-9665-00ad5b461690','6cf629cb-3074-42c1-b292-335852651665','dc5aab4d-512a-437b-a90f-c3f377a99947','5289946b-ab30-416a-87b6-65d1d5f2de85','744e4dea-10f1-4276-9508-ed2a094cf831','dfc72ba6-c362-443f-bd78-80c77e321cb3','636bc7cc-1a3f-4e70-a6ea-b40b00a0f487','d99a2159-514b-4de6-9cfe-72950a93837a','bb5da0c1-db88-4d6e-8a4e-c188f1b040ad','092c3aa5-e909-4d45-9723-f83797cad40e','7e7879b1-a02a-4576-8c29-e4f905cee441','f5f13370-3529-416d-9e96-ca4dfba962dc','5c2de42d-becc-4017-87ba-be9b88be0f43','5716beff-8168-4697-8583-0d5667c49c62','6a40665f-337e-4543-b369-580563f6f112','a96e88fa-b723-44c2-aed3-af3143b92895','fd6ce33b-e883-4751-ab73-c6ffcaaf61e8','ac50c296-8382-4436-9ebd-93f876c3a923','6d07e0b1-9e25-4329-baf1-b27259969aca','0af12820-404d-4ef8-8a7c-b63192d05c8d','044d230e-59a7-4a34-b209-270c082b9113','f708a879-808c-4d14-81b4-abddc7577473','efe73d8d-e952-41f9-a45c-9f4c52bb26e3','946fafd9-e4a8-4dc6-86bf-56d3cf3b86b0','cce507bf-6d80-4819-9499-94bd24875e80','f15585b2-809d-40fe-b633-7be0f7e2abb4','8a8cf29c-4776-4179-b3b3-79c2f9a3b928','bdbc5ab9-e28d-4fb5-88a0-37d667a0ce4a','61da6133-1bd8-45b9-b09f-9cc7915d9494','3c08eefa-638d-432b-9b4a-59d4ffeb922d','e432fcd1-4955-4546-b3e4-8d30e922a32c','b6650e19-12c9-4adf-a88c-5d5f7c1e080e','00f2843d-16c8-49b1-ab8a-477819ebcb0a','6c73a4eb-7e14-40b8-8a6f-9faab91e17a6','71a26ba0-20cd-4ff0-9028-beba03609a34','3e9a381f-f278-466d-ba3d-d136edf48cb5','1a3ee797-3251-4912-8b61-4cf514a0b8af','b2b36e66-b5c5-4f57-ab44-0ba1929497f8','3d47565c-0975-4780-b02d-01ee5d65c339','4e9f89c0-5728-4cea-a516-91b546f6724b','8120ae7b-f013-496b-89b6-77c5a0182d89','14d8c539-dac0-4331-bcb5-df3530559bbc','40de6571-24fd-40ac-8a3c-6c79455b0c5d','b97f1083-7076-4cfc-9cfa-fc5f99c860c2','61bc5201-8a4a-420d-94c9-75d0b0533e17','829bfaa8-9093-4229-8de5-154eef19251f','98e0844c-9905-43dc-9f90-297706e934ae','1193c428-71a3-4ef3-9d7c-20b6d4bf8d66','d3682ca0-073a-4dce-b226-971822523d15','c0e80803-3bb1-4263-b89d-f00c4fe8c066','e2e3db35-b0e0-4bfe-b053-720533e78231','00b4e542-09ba-4bc5-8303-612e892a9f3e','b511d9ce-c098-4165-87a4-69795e824a75','0bba745e-5f03-46a5-bb24-3e02eb80063c','6b76dce6-ef53-42da-8c44-23e6fba71414','1923dfaa-15ee-4bc2-bacc-e6204d341da5','bd60d5a4-a2cd-419d-8191-0c9885de60d9','80cf4227-4419-4923-8c55-79af41907749','bd785990-06ac-4cea-8f99-6ff6f50db41b','6081cce5-c417-429d-9198-4fcc640a0102','f15f2b28-4219-4357-a35c-b6c4da02d365','6f663be3-e8bf-4e20-b6a0-79ce0edf03cd','6074446b-f38e-4e96-96fb-63969294c359','150425b0-4fd5-4c83-9ec4-908cf45fde56','5e9c597d-c63f-4cd3-a845-47bbbf8a639d','a9d87ba9-26f0-4730-8842-3baac2e9d6f7','c7d6c95e-06c2-4ee7-8af0-2bc5da1c944a','bdd12c5c-de0c-4fa3-8447-d331e084a05d','4e2a79b9-f411-4f29-b9c0-ed06daf63507','470aca63-3e4d-42ae-8def-551eb39f0b34','f9d151e5-5dc0-484c-9ab9-dfc61b189b85');"

# optimize postgres queries
test "null" != "${PATRON_ACTION_SESSION}" && psql -a -c "vacuum verbose analyze ${TENANT}_mod_circulation_storage.patron_action_session;"
test "null" != "${REQUESTS}" && psql -a -c "vacuum verbose analyze ${TENANT}_mod_circulation_storage.request;"
test "null" != "${LOANS}" && psql -a -c "vacuum verbose analyze ${TENANT}_mod_circulation_storage.loan;"

exit 0;