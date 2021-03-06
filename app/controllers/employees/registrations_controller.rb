# frozen_string_literal: true
require 'util_module_app'

class Employees::RegistrationsController < Devise::RegistrationsController
  include UtilModuleApp

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    if corporate_email?()
      company = create_company()
      insert_company_in_params(company.id)
      super
      check_admin()
    else
      flash[:alert] = 'Esse e-mail não é corporativo!'
      redirect_to new_employee_registration_path
    end
  end

  # GET /resource/edit
  def edit
   super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute, :company_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute, :company_id])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  private
  def corporate_email?
    if parameter_email_exists?

      employee_email = params[:employee][:email].downcase
      
      invalid_email_suffixes.each do |key, email|
        return false if employee_email.include? email
      end
      return true
    end
    false
  end

  def invalid_email_suffixes
    UtilModuleApp::NON_CORPORATE_EMAILS
  end

  def parameter_email_exists?
    params[:employee] && params[:employee][:email]
  end

  def insert_company_in_params(company_id)
    params[:employee][:company_id] = company_id
  end

  def email_suffix
    params_email = String.new params[:employee][:email]

    index = params_email.index('@')

    size = params_email.size

    params_email[index..size]
  end

  def create_company
    Company.find_or_create(email_suffix())
  end

  def check_admin
    CompanyAdmin.create_or_find_admin(resource)
  end

end
