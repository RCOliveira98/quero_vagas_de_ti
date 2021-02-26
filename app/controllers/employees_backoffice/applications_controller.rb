class EmployeesBackoffice::ApplicationsController < EmployeesBackofficeController
    before_action :authenticate_employee!

    def index
        @applications = []
        company = Company.find(current_employee.company_id)
        
        company.jobs.each do |job|
            job.applications.each do |app|
                @applications.push(app)
            end
        end
        @applications
    end
end
