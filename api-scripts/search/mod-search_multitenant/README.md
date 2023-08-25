## mod-search load test:
When we do any query search in Inventory App in UI, requests are forwarded to mod-search. Following are the API calls that are tested in this JMeter script

`GET /search/authorities?query=keyword all ${cqlAuthQuery}&limit=100` <br />
`GET /search/authorities?query=keyword any ${cqlAuthQuery}&limit=100` <br />
`GET /search/authorities?query=keyword = ${cqlAuthQuery}&limit=100` <br />
`GET /search/authorities?keyword <> ${cqlAuthQuery}&limit=100`<br />
`GET /search/authorities?query=keyword == ${cqlAuthQuery}&limit=100` <br />
`GET /search/authorities?query=keyword all *${cqlAuthQuery}*&limit=100` <br />
`GET /search/authorities?query=keyword all ${cqlAuthQuerySentence}&limit=100` <br />
`GET /search/authorities?query=keyword any ${cqlAuthQuerySentence}&limit=100` <br />
`GET /search/authorities?query=keyword == ${cqlAuthQuerySentence}&limit=100` <br />
`GET /search/authorities?keyword <> ${cqlAuthQuerySentence}&limit=100` <br />
`GET /search/authorities?query=keyword = ${cqlAuthQuerySentence}&limit=100` <br />
`GET /search/authorities?query=keyword = *${cqlAuthQuerySentence}*&limit=100` <br />
`GET /search/instances?query=subjects all ${cqlBoolAndQuery}&limit=100` <br />
`GET /search/instances?query=subjects all ${cqlBoolOrQuery}&limit=100` <br />
`GET /search/instances?query=subjects = (${cqlBoolSubjectOrQuery})&limit=100` <br />
`GET /search/instances?query=subjects all ${cqlBoolSubjectNotQuery}&limit=100` <br />
`GET /search/instances?query=contributors all ${cqlContributorsWordQuery}&limit=100` <br />
`GET /search/instances?query=contributors = ${cqlContributorsWordQuery}*&limit=100` <br />
`GET /search/instances?query=contributors = *${cqlContributorsWordQuery}&limit=100` <br />
`GET /search/instances?query=contributors any ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=contributors == ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query==contributors <> ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=contributors all ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=keyword all ${cqlFilterSentenceQuery} AND languages == ${cqlFilterLanguageQuery}&limit=100` <br />
`GET /search/instances?query=languages == ${cqlFilterLanguageQuery} AND items.status.name == Available&limit=100` <br />
`GET /search/instances?query=languages == (${cqlFilterLanguageQuery}) AND items.status.name == (Available OR In transit)&limit=100` <br />
`GET /search/instances?query=languages == ${cqlFilterLanguageQuery}&limit=100` <br />
`GET /search/instances?query=keyword all ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=keyword = ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=keyword any ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=keyword == ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/?query=keyword <> ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=keyword = ${cqlAuthQuery}*&limit=100` <br />
`GET /search/?query=keyword <> ${cqlAuthQuery}&limit=100` <br />
`GET /search/instances?query=subjects all ${cqlAuthQuery}&limit=100` <br />
`GET /search/instances?query=subjects = ${cqlAuthQuery}*&limit=100` <br />
`GET /search/instances?query=subjects = *${cqlAuthQuery}&limit=100` <br />
`GET /search/instances?query=subjects any ${cqlContributorsTwoWordQuery}&limit=100` <br />
`GET /search/instances?query=subjects == ${cqlAuthQuery}&limit=100` <br />
`GET /search/instances?query=subjects <> ${cqlSubjectQuery}&limit=100` <br />
`GET /search/instances?query=title all ${cqlTitleSentenceQuery}&limit=100` <br />
`GET /search/instances?query=title any ${cqlTitleSentenceQuery}&limit=100` <br />
`GET /search/instances?query=title == ${cqlTitleSentenceQuery}&limit=100` <br />
`GET /search/instances?query=title <> ${cqlTitleSentenceQuery}&limit=100` <br />
`GET /search/instances?query=title all ${cqlAuthQuery}*&limit=100` <br />
`GET /search/instances?query=title all *${cqlAuthQuery}&limit=100` <br />

This is a multi-tenant JMeter. Currently it is designed to run on 2 tenants fs09000000 and fs07000001 in lcp1 cluster in PTF environment. However, we can add any number of tenants to scale across multitenant environment. 

This script needs supporting data in the form of csv files. Records inside these csv files are query parameters to the mod-search API calls above. Supporting data is generated from random list of words https://www.mit.edu/~ecprice/wordlist.10000 

For more details - https://wiki.folio.org/pages/viewpage.action?pageId=79487503