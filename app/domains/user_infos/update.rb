module UserInfos
  class Update < Schema
    attribute :first_name, :string
    attribute :last_name, :string
    attribute :phone, :string
    attribute :date_of_birth, :date
    attribute :cpf, :string
    attribute :rg, :string
    attribute :rg_uf, :string
    attribute :gender, :string
    
    attr_accessor :address_attributes

    validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
    validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
    validates :phone, presence: true, 
                      format: { with: /\A\d{10,15}\z/, message: "deve conter apenas números (10 a 15 dígitos)" }
    validates :date_of_birth, presence: true
    validates :cpf, presence: true, 
                    format: { with: /\A\d{11}\z/, message: "deve conter 11 dígitos" }
    validates :rg, presence: true
    validates :rg_uf, presence: true, inclusion: { in: UserInfo.rg_ufs.keys.map(&:to_s) }
    validates :gender, presence: true, inclusion: { in: UserInfo.genders.keys.map(&:to_s) }
    validate :date_of_birth_valid
    validate :address_attributes_valid

    def validate!
      unless valid?
        error_message = errors.full_messages.join(", ")
        raise Error::InvalidParams.new(error_message)
      end
      self
    end

    def initialize(attributes = {})
      super
      # Extrair address_attributes se presente
      if attributes.is_a?(Hash)
        @address_attributes = attributes[:address_attributes] || attributes['address_attributes']
      end
    end

    def to_params!
      {
        first_name: first_name,
        last_name: last_name,
        phone: phone,
        date_of_birth: date_of_birth,
        cpf: cpf,
        rg: rg,
        rg_uf: rg_uf,
        gender: gender,
        address_attributes: @address_attributes
      }
    end

    private

    def date_of_birth_valid
      return if date_of_birth.blank?

      if date_of_birth > Date.current
        errors.add(:date_of_birth, "não pode ser no futuro")
      elsif date_of_birth < 120.years.ago
        errors.add(:date_of_birth, "data inválida")
      end
    end

    def address_attributes_valid
      return if address_attributes.blank?

      addr = address_attributes
      required_fields = [:street, :number, :neighborhood, :city, :state, :zip_code]
      
      required_fields.each do |field|
        if addr[field.to_s].blank? && addr[field].blank?
          errors.add(:address_attributes, "#{field} é obrigatório")
        end
      end

      if addr[:zip_code].present? || addr["zip_code"].present?
        zip = addr[:zip_code] || addr["zip_code"]
        unless zip.match?(/\A\d{5}-?\d{3}\z/)
          errors.add(:address_attributes, "CEP deve estar no formato 00000-000")
        end
      end
    end
  end
end

