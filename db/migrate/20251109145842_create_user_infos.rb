class CreateUserInfos < ActiveRecord::Migration[8.0]
  def change
    create_enum :genders, %w[male female not_respond]
    create_enum :ufs, %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO]

    create_table :user_infos do |t|
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :phone, null: false, default: ""
      t.date :date_of_birth, null: false
      t.string :cpf, null: false, default: ""
      t.string :rg, null: false, default: ""
      t.enum :gender, enum_type: :genders, null: false
      t.enum :rg_uf, enum_type: :ufs, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
