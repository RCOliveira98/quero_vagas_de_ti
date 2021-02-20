class CompaniesController < ApplicationController
    layout 'application'

    def index
        @companies = Company.all
    end

    def search_name
        @companies = Company.select_by_name term_param
    end

    private
    def term_param
        params[:term]
    end
end