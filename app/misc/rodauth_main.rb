# frozen_string_literal: true

require 'sequel/core'
require 'jwt'

SECRET_KEY = SecureRandom.hex(64)

# RodauthMain
class RodauthMain < Rodauth::Rails::Auth
  configure do
    enable :create_account, :login, :logout, :jwt, :change_password,
           :password_expiration

    account_password_hash_column :password_hash
    password_expiration_id_column :account_id
    password_expiration_changed_at_column :changed_at
    require_password_change_after 10.days
    password_minimum_length 8
    password_maximum_bytes 72
    require_login_confirmation? false
    change_password_requires_password? true
    require_password_confirmation? false
    only_json? true
    jwt_secret SECRET_KEY
    login_param 'email'

    db Sequel.postgres(extensions: :activerecord_connection, keep_reference: false)
    convert_token_id_to_integer? { Account.columns_hash['id'].type == :integer }
    rails_controller { RodauthController }

    # Uncomment this to manually update the changed_at column when change-password is used
    # after_change_password do
    #   user_id = account_from_session[:id]
    #   unless user_id.nil?
    #     password_change_record = AccountPasswordChangeTime.find_by(account_id: user_id)
    #     password_change_record&.update(changed_at: Time.now)
    #   end
    # end
  end
end
