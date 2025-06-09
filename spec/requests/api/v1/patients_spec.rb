require "swagger_helper"

RSpec.describe "api/v1/patients", type: :request do
  path "/api/v1/patients/adherence_score.json" do
    get("Get the adherence score for a patient") do
      security [basic_auth: [""]]
      consumes "application/json"
      produces "application/json"

      response(200, "Returns the adherence score") do
        let(:patient) { create(:patient, created_at: 10.days.ago) }
        let!(:injections) do
          [
            create(:injection, patient: patient, created_at: 10.days.ago),
            create(:injection, patient: patient, created_at: 6.days.ago),
            create(:injection, patient: patient, created_at: 4.days.ago),
            create(:injection, patient: patient, created_at: 2.days.ago)
          ]
        end
        let(:Authorization) { "Basic #{::Base64.strict_encode64("#{patient.key}:#{patient.secret}")}" }

        run_test!
      end
    end
  end

  path "/api/v1/patients.json" do
    post("Create a new patient") do
      consumes "application/json"
      produces "application/json"

      parameter name: :patient, in: :body, schema: {
        type: :object,
        properties: {
          schedule_days: {
            description: "Treatment schedule in days, e.g. 3",
            type: :integer
          }
        }
      }

      response(201, "Create a new patient with 5 days injection schedule") do
        let(:patient) do
          {
            schedule_days: 5
          }
        end

        run_test!
      end

      response(422, "Creating a patient with invalid schedule returns a semantic error") do
        let(:patient) do
          {
            schedule_days: "asdf"
          }
        end

        run_test!
      end
    end
  end
end
