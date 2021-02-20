class EmployeesBackoffice::HomeController < EmployeesBackofficeController
    before_action :authenticate_employee!

    def index
    end
end