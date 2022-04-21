class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true

  enum status: { Aktiv: 0, Innaktiv: 1 }
  validates :description, length: { maximum: 500 }
  validates :description, :status, :userId, :reportable_id, :reportable_type, presence: true
end
