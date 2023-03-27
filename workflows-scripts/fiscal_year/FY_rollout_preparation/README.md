## Introduction
This is a script for generating data as preparation step for Fiscal year rollover testing.
It creates:
- configuration data;
- fiscal years;
- ledger;
- expence slasses;
- funds;
- budgets;
- orders with 2 order lines:
	-status: open, closed, 
	-types: One-time, Ongoing, Ongoing subscriptions;
- open ongoing orders with 200 lines.


## Usage
- Modify credentials.csv to have the correct values before running the script.
- Choose in JMeter script property:
    HOSTNAME (starting from okapi-);
	prefix, fiscalYearCode, rolFiscalYearCode - Should be changed each time when new FY is created;
	number of users for ThreadGroup - depends on data quantity.
- After script stops run fiscal year rollover for the corresponding year in UI.
