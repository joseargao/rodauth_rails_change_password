# README

This is a minimal rails project that demonstrates how the changed_at column does not get automatically updated when
change-password is used. The rspec test fails, but it can be made to pass by uncommenting this hack in rodauth_main.rb:

    # Uncomment this to manually update the changed_at column when change-password is used
    after_change_password do
      user_id = account_from_session[:id]
      unless user_id.nil?
        password_change_record = AccountPasswordChangeTime.find_by(account_id: user_id)
        password_change_record&.update(changed_at: Time.now)
      end
    end
