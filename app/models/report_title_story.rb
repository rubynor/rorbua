class ReportTitleStory < ApplicationRecord
  belongs_to :report
  validates :title, presence: true
  validates :title, uniqueness: true
end
