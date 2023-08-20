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

    accounts.define(identifier: :user_accounts, scope_identifier: user_scope)
    accounts.define(identifier: :company_account, scope_identifier: nil)
    accounts.define(identifier: :vendor_account, scope_identifier: vendor_scope)

    accounts.define(identifier: :user_department_account, scope_identifier: user_scope)
    accounts.define(identifier: :company_department_account, scope_identifier: nil)
  end

  config.define_transfers do |transfers|
    transfers.define(from: :user_account, to: :company_account,  code: :repayment)
    transfers.define(from: :company_account,  to: :user_account, code: :loan)

    transfers.define(from: :user_department_account, to: :company_department_account,  code: :repayment)
    transfers.define(from: :company_department_account, to: :user_department_account,  code: :repayment)

    transfers.define(from: :company_account, to: :vendor_account, code: :payment)
  end
end
