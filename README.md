# README

Sample rails app to populate sub-ledgers from main ledgers using transfer events

> Note: It uses escrow account for sub-ledger (department)

### Workflow

- [config/initializers/double_entry.rb](https://github.com/HandOfGod94/ledger_playground/blob/main/config/initializers/double_entry.rb), sub-ledgers and new transfer_and_broadcast method to double_entry
- [config/initializers/listeners.rb](https://github.com/HandOfGod94/ledger_playground/blob/main/config/initializers/listeners.rb), wire sub-ledger logic class to money_transferred event
- [app/observers/department_ledger_populator.rb](https://github.com/HandOfGod94/ledger_playground/blob/main/app/observers/department_ledger_populator.rb), actual logic to add entry to sub-ledger based on transaction event.

In order for this to work, one will have to do `DoubleEntry.transfer_and_broadcast(...)` with same contract as `DoubleEntry.transfer`.

### Caveat
- `after_commit` hooks might be a bit dangerous, if we fail to record payment in sub-ledgers
  - `before_commit` hook from `AfterCommitEverywhere` doesn't work
- Need to use `main` branch of `double_entry` to capture credit_line and debit_line for each transaction. Although there are other ways
  to fetch the same info.
- `detail` field should contain enough information to figure out sub-ledger account
