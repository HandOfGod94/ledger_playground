class Vendor < ApplicationRecord
  attribute :name, :string

  def account
    DoubleEntry.account(:vendor_account, scope: self)
  end
end
