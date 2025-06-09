class AdherenceScore
  attr_reader :patient
  delegate :schedule_days, to: :patient

  def initialize(patient)
    @patient = patient
  end

  def expected_injections
    @expected_injections ||= injection_schedule.count
  end

  def actual_injections
    @actual_injections ||= injections.values.reduce(0, &:+)
  end

  def on_time_injections
    @on_time_injections ||= injection_schedule.reduce(0) do |acc, date|
      acc + [1, injections[date] || 0].min
    end
  end

  def score
    (on_time_injections.to_f / expected_injections.to_f) * 100.0
  end

  private

  def injections
    @injections ||= Injection.where(patient:).group_by_day(:created_at).count
  end

  def injection_schedule
    date = patient.created_at.to_date
    schedule = []

    while date <= schedule_until
      schedule << date
      date += patient.schedule_days.days
    end

    schedule
  end

  def schedule_until
    Date.today
  end
end
