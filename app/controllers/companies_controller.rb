class CompaniesController < ApplicationController
    before_action :company_find, only: %i[profile jobs]
    layout 'application'

    def index
        @companies = Company.all
    end

    def profile
        @jobs = @company.select_jobs
    end

    def search_name
        @companies = Company.select_by_name term_param
    end

    def jobs
        @jobs = @company.select_jobs_by_title term_param
    end

    private
    def term_param
        params[:term]
    end

    def company_find
        @company = Company.find(params[:id])
    end
end