# frozen_string_literal: true

# RodauthApp
class RodauthApp < Rodauth::Rails::App
  configure RodauthMain

  route(&:rodauth)
end
