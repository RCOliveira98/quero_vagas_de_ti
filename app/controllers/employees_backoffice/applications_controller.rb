class EmployeesBackoffice::ApplicationsController < EmployeesBackofficeController
    before_action :authenticate_employee!

    def index
        @applications = []
        company = Company.find(current_employee.company_id)
        
        company.jobs.each do |job|
            unless job.cancelada?
                job.applications.each do |app|
                    @applications.push(app)
                end 
            end
        end
        @applications
    end

    def show
        begin
            @application = Application.find(params[:id])
        rescue => exception
            flash[:alert] = 'Você tentou acessar uma candidatura que não existe'
            redirect_to employees_backoffice_applications_path
        end
    end
end
