class Car < ApplicationRecord

  
  
  belongs_to :user
  validates :name, presence: true
  validates :model, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "model", "name", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
