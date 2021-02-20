class CompaniesController < ApplicationController
    layout 'application'

    def index
        @companies = Company.all
    end
end