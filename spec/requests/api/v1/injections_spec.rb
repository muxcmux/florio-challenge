require "swagger_helper"

RSpec.describe "api/v1/injections", type: :request do
  path "/api/v1/injections.json" do
    get("List patient injections") do
      security [basic_auth: [""]]
      consumes "application/json"
      produces "application/json"

      response(200, "Returns a list of injections for the authenticated patient") do
        let(:patient) { create(:patient, created_at: 10.days.ago) }
        let!(:injections) do
          [
            create(:injection, patient: patient, created_at: 10.days.ago),
            create(:injection, patient: patient, created_at: 7.days.ago),
            create(:injection, patient: patient, created_at: 4.days.ago),
            create(:injection, patient: patient, created_at: 1.day.ago)
          ]
        end
        let(:Authorization) { "Basic #{::Base64.strict_encode64("#{patient.key}:#{patient.secret}")}" }

        run_test!
      end
    end

    post("Create a record of an injection") do
      security [basic_auth: [""]]
      consumes "application/json"
      produces "application/json"

      parameter name: :injection, in: :body, schema: {
        type: :object,
        properties: {
          dose: {
            description: "Dose in milliliters",
            type: :integer
          },
          drug_name: {
            description: "The name of the injected drug",
            type: :string
          },
          lot_number: {
            description: "Drug lot number. Must be 6 alphanumeric characters long",
            type: :string
          }
        }
      }

      response(201, "Create an injection record for a patient") do
        let(:patient) { create(:patient, created_at: 10.days.ago) }
        let(:Authorization) { "Basic #{::Base64.strict_encode64("#{patient.key}:#{patient.secret}")}" }

        let(:injection) do
          {
            dose: 100,
            drug_name: "Some drug",
            lot_number: "1234ab"
          }
        end

        run_test!
      end

      response(422, "Creating an injection with invalid data returns semantic errors") do
        let(:patient) { create(:patient, created_at: 10.days.ago) }
        let(:Authorization) { "Basic #{::Base64.strict_encode64("#{patient.key}:#{patient.secret}")}" }

        let(:injection) do
          {
            dose: "asdf",
            lot_number: "invalid"
          }
        end

        run_test!
      end
    end
  end
end
