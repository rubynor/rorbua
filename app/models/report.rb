class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true

  enum status: { Aktiv: 0, Innaktiv: 1 }
  enum tittle: { "Upassende innhold": 0,
                 "Seksuelt trakasserende": 1,
                 "Rasistisk innhold":2,
                 "Upassende bilde":3}
  validates :description, length: { maximum: 500 }
  validates :description, :status, :userId, :reportable_id, :reportable_type, :tittle, presence: true
end
