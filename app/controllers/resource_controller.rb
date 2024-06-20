# frozen_string_literal: true

# app/controllers/resource_controller.rb
class ResourceController < ApplicationController
  def index
    render json: { message: 'Rodauth Password Change Test App' }
  end
end
