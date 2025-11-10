class UserInfo < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :address, optional: true
  extend FriendlyId

  enum :gender, { male: "male", female: "female", not_respond: "not_respond" }
  enum :rg_uf, {
    AC: "AC",
    AL: "AL",
    AP: "AP",
    AM: "AM",
    BA: "BA",
    CE: "CE",
    DF: "DF",
    ES: "ES",
    GO: "GO",
    MA: "MA",
    MT: "MT",
    MS: "MS",
    MG: "MG",
    PA: "PA",
    PB: "PB",
    PR: "PR",
    PE: "PE",
    PI: "PI",
    RJ: "RJ",
    RN: "RN",
    RS: "RS",
    RO: "RO",
    RR: "RR",
    SC: "SC",
    SP: "SP",
    SE: "SE",
    TO: "TO"
  }

  friendly_id :full_name, use: :slugged

  has_one_attached :avatar

  validates :phone, presence: true, numericality: true, length: { minimum: 10, maximum: 15 }

  accepts_nested_attributes_for :address

  def full_name
    "#{first_name} #{last_name}"
  end
end
