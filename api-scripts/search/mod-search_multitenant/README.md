## mod-search load test:
When we do any query search in Inventory App in UI, requests are forwarded to mod-search. Following are the API calls that are tested in this JMeter script

`/search/authorities?query=keyword all ${cqlAuthQuery}&limit=100`
`/search/authorities?query=keyword any ${cqlAuthQuery}&limit=100`
`/search/authorities?query=keyword = ${cqlAuthQuery}&limit=100`
`/search/authorities?keyword <> ${cqlAuthQuery}&limit=100`
`/search/authorities?query=keyword == ${cqlAuthQuery}&limit=100`
`/search/authorities?query=keyword all *${cqlAuthQuery}*&limit=100`
`/search/authorities?query=keyword all ${cqlAuthQuerySentence}&limit=100`
`/search/authorities?query=keyword any ${cqlAuthQuerySentence}&limit=100`
`/search/authorities?query=keyword == ${cqlAuthQuerySentence}&limit=100`
`/search/authorities?keyword <> ${cqlAuthQuerySentence}&limit=100`
`/search/authorities?query=keyword = ${cqlAuthQuerySentence}&limit=100`
`/search/authorities?query=keyword = *${cqlAuthQuerySentence}*&limit=100`

This is a multi-tenant JMeter. Currently it is designed to run on 2 tenants fs09000000 and fs07000001 in lcp1 cluster in PTF environment. However, we can add any number of tenants to scale across multitenant environment. 

This script needs supporting data in the form of csv files. Records inside these csv files are query parameters to the mod-search API calls above.

For more details - https://wiki.folio.org/pages/viewpage.action?pageId=79487503