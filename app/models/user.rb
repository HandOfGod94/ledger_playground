class User < ApplicationRecord
  attribute :name, :string

  belongs_to :department

  def account
    DoubleEntry.account(:user_accounts, scope: self)
  end
end
