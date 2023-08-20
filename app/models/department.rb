class Department < ApplicationRecord
  attribute :name, :string

  has_many :users, dependent: :destroy
end
