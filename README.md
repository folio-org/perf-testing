# Introduction

Carrier is an open source continuous performance testing toolkit.
It consists of tools and practices to integrate non-functional tests into delivery pipeline and organize effective feedback loop. 

FOLIO Performance Task Force adopts this toolkit to carry out performance testing of back end modules for the community.

### Installation

Details to install carrier-io are in /carrier-io/README.md
A few things to note: 
1. If using the provided carrier-io Jenkinsfile, must replace "[TBD]" with appropriate values
2. If want to profile backend modules, add the content of /carrier-io/docker-entrypoint-profiling/addendum.sh into your module's startup script. This will install the Uber profile and 
sets the destination of the InfluxDB host (temporarily having the value "[TBD]") to forward the profiled data.

### Contributions
The jmeter-scripts directory is organized as follows:
/jmeter-scripts
-- /workflows
-- -- /check-in-check-out
-- -- -- /edelweiss
-- -- -- -- /folio.jmx + others

The directory is organized by the workflows. Each workflows should be named. Here we have a "check-in-check-out" workflow.
Under each workflow is the FOLIO release. It can be a release name, e.g. "Edelweiss", or version number.
Under each FOLIO release folder are the test artifacts. These include the JMeter script, any data and config file that the JMeter script references, and other files/scripts that are pertinent to this testing effort. 
JMeter script's name should be unique across the repository.

If using the check-in-check-out/edelweiss/folio.jmx JMeter script as is, replace [okapi-hostname-without-http-protocol] with the real value.
