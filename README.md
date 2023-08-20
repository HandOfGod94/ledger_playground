# README

Sample rails app to populate sub-ledgers from main ledgers using transfer events

> Note: It uses escrow account for sub-ledger (department)

### Caveat
- `after_commit` hooks might be a bit dangerous, if we fail to record payment in sub-ledgers
  - `before_commit` hook from `AfterCommitEverywhere` doesn't work
- Need to use `main` branch of `double_entry` to capture credit_line and debit_line for each transaction. Although there are other ways
  to fetch the same info.
- `detail` field should contain enough information to figure out sub-ledger account
