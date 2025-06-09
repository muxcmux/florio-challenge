require "rails_helper"

describe Patient, type: :model do
  let(:patient) { create(:patient) }

  it "creates creds automatically" do
    expect(patient.key).to be_present
    expect(patient.secret).to be_present
  end

  it "does not update creds on record update" do
    key = patient.key.clone
    secret = patient.secret.clone
    patient.update(created_at: 15.days.ago)
    patient.reload

    expect(key).to eq(patient.key)
    expect(secret).to eq(patient.secret)
  end

  it "authenticate" do
    expect(Patient.authenticate("test", "test")).to be_blank
    expect(Patient.authenticate(patient.key, patient.secret)).to eq(patient)
  end
end
