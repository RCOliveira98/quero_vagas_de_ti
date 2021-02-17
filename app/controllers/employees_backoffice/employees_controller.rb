class EmployeesBackoffice::EmployeesController < EmployeesBackofficeController
    def show
        @employee = Employee.find(params[:id])
    end
end
