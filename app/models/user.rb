class User < ApplicationRecord
  attribute :name, :string

  belongs_to :department
end
