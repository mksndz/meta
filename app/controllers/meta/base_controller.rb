module Meta
  class BaseController < ApplicationController

    layout 'admin'

    def index
    end

    def current_ability
      @current_ability ||= AdminAbility.new(current_admin)
    end

  end
end

