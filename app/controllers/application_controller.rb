class ApplicationController < ActionController::Base
    layout :layout_by_resource

    protected
    def layout_by_resource
        devise_controller? ? 'devise' : 'application'
    end
end
