class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true

  enum status: { Aktiv: 0, Innaktiv: 1 }
  enum tittle: { "Uppassende ting": 0,
                 "Veldig ting": 1,
                 "sykt ting":2}
  validates :description, length: { maximum: 500 }
  validates :description, :status, :userId, :reportable_id, :reportable_type, :tittle, presence: true
end
