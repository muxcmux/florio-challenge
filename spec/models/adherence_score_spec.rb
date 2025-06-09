require "rails_helper"

describe Patient, type: :model do
  let!(:patient) { create(:patient, created_at: 10.days.ago) }
  let!(:injections) do
    [
      create(:injection, patient:, created_at: 10.days.ago),
      create(:injection, patient:, created_at: 6.days.ago),
      create(:injection, patient:, created_at: 4.days.ago),
      create(:injection, patient:, created_at: 3.days.ago),
      create(:injection, patient:, created_at: 1.days.ago)
    ]
  end

  let(:score) { AdherenceScore.new(patient) }

  it "it works" do
    expect(score.actual_injections).to eq 5
    expect(score.expected_injections).to eq 4
    expect(score.on_time_injections).to eq 3
    expect(score.score).to eq 75.0
  end

  it "it works correctly when there's two injections on an expected day" do
    create(:injection, patient: patient, created_at: 10.days.ago)

    expect(score.actual_injections).to eq(6)
    expect(score.expected_injections).to eq(4)
    expect(score.on_time_injections).to eq(3)
    expect(score.score).to eq(75.0)
  end

  it "it works without any injections" do
    Injection.delete_all

    expect(score.actual_injections).to eq(0)
    expect(score.expected_injections).to eq(4)
    expect(score.on_time_injections).to eq(0)
    expect(score.score).to eq(0.0)
  end

  it "it works with a different schedule" do
    patient.update(schedule_days: 2)

    expect(score.actual_injections).to eq(5)
    expect(score.expected_injections).to eq(6)
    expect(score.on_time_injections).to eq(3)
    expect(score.score).to eq(50.0)
  end
end
