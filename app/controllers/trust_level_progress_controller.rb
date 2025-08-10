# frozen_string_literal: true

class TrustLevelProgressController < ApplicationController
  requires_plugin 'discourse-trust-level-progress'
  before_action :ensure_logged_in

  def show
    user = User.find_by_username(params[:username])
    guardian.ensure_can_see_user_summary?(user)

    calculator = TrustLevelProgressCalculator.new(user)
    render json: calculator.progress
  end
end
