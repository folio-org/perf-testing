## Introduction
This is a script for generating data as preparation step for Fiscal year rollover testing.
It creates:
- configuration data:
	- poline limit;
	- organization;
	- materialType;
	- acquisitionMethod;
	- location;
	- identifierType;
- fiscal years (current and to rollover to);
- ledger (for the current fiscal year);
- expense classes;
- funds;
- budgets;
- orders with 2 order lines:
	-status: open, closed, 
	-types: One-time, Ongoing, Ongoing subscriptions;
- open ongoing orders with 200 lines.


## Usage
- Modify credentials.csv to have the correct values before running the script.
- Choose in JMeter script property:
    HOSTNAME - starting from "okapi-".
	prefix - value of any format. Must be unique among the previous tests. Simple solution - integer number incremented by 1 each test run. Should be changed each time when a new FY is created. 
	fiscalYearCode, rolFiscalYearCode - value must start with uppercase letters and end with a four-digit numeric. Example - FY2020. Must be unique among other fiscal years. Should be changed each time when new FY is created. 
	number of users for ThreadGroup - depends on data quantity.
- After script stops run fiscal year rollover for the corresponding year in UI.
- Before each test run data should be deleted. It can be done directly in the database with next commands:

	truncate table fs09000000_mod_finance_storage.budget cascade;
	truncate table fs09000000_mod_finance_storage.transaction  cascade;
	truncate table fs09000000_mod_finance_storage.budget_expense_class cascade;
	truncate table fs09000000_mod_finance_storage.expense_class  cascade;
	truncate table fs09000000_mod_finance_storage.fund cascade;
	truncate table fs09000000_mod_finance_storage.fund_type cascade;
	truncate table fs09000000_mod_finance_storage.fiscal_year cascade;
	truncate table fs09000000_mod_finance_storage.ledger cascade;
	truncate table fs09000000_mod_finance_storage.group_fund_fiscal_year cascade;
	truncate table fs09000000_mod_orders_storage.purchase_order cascade;
	truncate table fs09000000_mod_orders_storage.po_line cascade;
	truncate table fs09000000_mod_orders_storage.titles cascade;
	truncate table fs09000000_mod_notes.note cascade;