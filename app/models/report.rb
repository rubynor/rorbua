class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  validates :description, :status, :reportable_type, :reportable_id, presence: true
  validates :description, length: { maximum: 250 }

  enum status: { Aktiv: 0, Avsluttet: 1 }
end
