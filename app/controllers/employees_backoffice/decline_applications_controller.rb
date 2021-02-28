class EmployeesBackoffice::DeclineApplicationsController < EmployeesBackofficeController
    before_action :authenticate_employee!
    
    def new
        @decline_application = DeclineApplication.new
    end

    def create
        @decline_application = DeclineApplication.new(params_decline_application())
        set_employee()
        set_job_application()

        if @decline_application.save()
            flash[:notice] = 'Candidatura reprovada!'
            redirect_to employees_backoffice_applications_path
        else
            render :new
        end
    end

    private
    def params_decline_application
        params.require(:decline_application).permit(:application_id, :employee_id, :justification)
    end

    def set_employee
        @decline_application.employee = current_employee
    end

    def set_job_application
        @decline_application.application =  Application.find(params[:application])
    end
end