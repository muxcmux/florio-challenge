class Injection < ApplicationRecord
  belongs_to :patient

  validates :lot_number, format: {with: /[a-zA-Z0-9]/}, length: {is: 6}
  validates :drug_name, presence: true
  validates :dose, numericality: {only_integer: true}
end
