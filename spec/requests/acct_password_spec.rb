# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account Tests', type: :request do
  def get_credential(role, param)
    @credentials[role][param.to_sym]
  end

  def authorise(role)
    post '/login', params: @credentials[role], as: :json
    # pp "LOGIN #{role.to_s.upcase}: #{JSON.parse(response.body)}"
  end

  def create_account(role)
    email = get_credential(role, :email)
    name = get_credential(role, :name)
    password = get_credential(role, :password)

    post '/create-account', params: { name:, email:, password:, 'password-confirm': password }, as: :json
    # pp "CREATE ACCOUNT #{role.to_s.upcase}: #{JSON.parse(response.body)}"
  end

  def display_accounts
    Account.all.each do |account|
      puts account.inspect
    end
  end

  def display_accounts_password_change_times
    AccountPasswordChangeTime.all.each do |account|
      puts account.inspect
    end
  end

  def modify_account_password_change_time(email, new_time)
    acct_id = Account.find_by(email:).id
    change_time_entry = AccountPasswordChangeTime.find_by(account_id: acct_id)
    change_time_entry.update(changed_at: new_time)
  end

  before(:all) do
    @credentials = {
      user: {
        email: 'user@example.com',
        password: 'userpassword',
        name: 'test user',
        'password-confirm': 'userpassword'
      },
      admin: {
        email: 'admin@example.com',
        password: 'adminpassword',
        name: 'test admin',
        'password-confirm': 'adminpassword'
      }
    }

    create_account(:user)
    @user_account = Account.find_by(email: get_credential(:user, :email))
  end

  describe 'Password expiry', type: :feature do
    it 'expires for a user account' do
      authorise(:user)
      expect(response).to have_http_status(:ok)

      # display_accounts_password_change_times

      modify_account_password_change_time(@credentials[:user][:email], 11.days.ago)

      authorise(:user)
      expect(response).to have_http_status(:bad_request)
    end

    it 'refreshes after the password is changed' do
      password = get_credential(:user, :password)
      new_password = 'newpassword'
      post '/change-password',
           params: { password:, 'new-password': new_password },
           headers: response.headers, as: :json
      # pp "CHANGE PASSWORD #{JSON.parse(response.body)}"

      expect(response).to have_http_status(:ok)
      post '/logout', as: :json

      # display_accounts_password_change_times

      @credentials[:user][:password] = new_password
      authorise(:user)
      expect(response).to have_http_status(:ok)
    end
  end
end
