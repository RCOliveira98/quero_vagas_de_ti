class CompaniesController < ApplicationController
    before_action :company_find, only: %i[show profile edit update]
    before_action :authenticate_employee!, except: %i[show]

    def show
    end

    def profile
    end

    def edit
    end

    def update
        if @company.update(company_params())
            flash[:notice] = 'Perfil atualizado!'
            redirect_to profile_company_path(@company)
        else
            render :edit
        end
    end

    private

    def company_find
        @company = Company.find(params[:id])
    end

    def company_params
        params.require(:company).permit(:name, :cnpj, :email_suffix,
                                        :site, :country, :state, :city,
                                        :zip_code, :neighborhood, :logradouro)
    end
end