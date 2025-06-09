class Patient < ApplicationRecord
  encrypts :secret
  has_many :injections

  before_validation :generate_credentials

  validates :schedule_days, numericality: {only_integer: true, greater_than: 0}

  class << self
    def authenticate(key, secret)
      patient = where(key:).first
      return nil if patient.blank?

      ActiveSupport::SecurityUtils.secure_compare(secret, patient.secret) ? patient : nil
    end
  end

  private

  def generate_credentials
    self.key = SecureRandom.uuid if key.blank?
    self.secret = SecureRandom.hex(16) if secret.blank?
  end
end
