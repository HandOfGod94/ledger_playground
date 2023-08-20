require 'double_entry'

DoubleEntry.configure do |config|
  # Use json(b) column in double_entry_lines table to store metadata instead of separate metadata table
  config.json_metadata = true

  config.define_accounts do |accounts|
    user_scope = lambda do |user|
      raise 'not a User' unless user.instance_of?(User)

      user.id
    end

    vendor_scope = lambda do |user|
      raise 'not a Vendor' unless user.instance_of?(Vendor)

      vendor.id
    end

    department_scope = lambda do |department|
      raise 'not a Department' unless department.instance_of?(Department)

      department.id
    end

    # core functionality ledgers
    accounts.define(identifier: :user_accounts, scope_identifier: user_scope)
    accounts.define(identifier: :company_account, scope_identifier: nil)
    accounts.define(identifier: :vendor_account, scope_identifier: vendor_scope)

    # sub ledgers derived from core-functionality ledgers
    accounts.define(identifier: :department_account, scope_identifier: department_scope)
    accounts.define(identifier: :user_department_account, scope_identifier: user_scope)
  end

  config.define_transfers do |transfers|
    # core functionality ledgers
    transfers.define(from: :user_account, to: :company_account,  code: :repayment)
    transfers.define(from: :company_account,  to: :user_account, code: :loan)
    transfers.define(from: :company_account, to: :vendor_account, code: :payment)

    # sub ledgers derived from core-functionality ledgers
    transfers.define(from: :user_department_account, to: :department_account, code: :department_transaction)
  end
end

module DoubleEntry
  include AfterCommitEverywhere
  include Wisper::Publisher

  class << self
    def transfer_and_broadcast(amount, options = {})
      from_account = options[:from]
      to_account   = options[:to]

      DoubleEntry.lock_accounts(from_account, to_account) do
        credit_line, debit_line = DoubleEntry.transfer(amount, options)
        after_commit do
          broadcast(:money_transferd, { credit_line:, debit_line:, transfer: { amount:, options: } })
        end
      end
    end
  end
end
