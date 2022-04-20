json.extract! report, :id, :description, :status, :userId, :reportable_id, :reportable_type, :created_at, :updated_at
json.url report_url(report, format: :json)
