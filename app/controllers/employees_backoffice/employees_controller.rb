class EmployeesBackoffice::EmployeesController < EmployeesBackofficeController
    before_action :employee_find, only: %i[show edit update]
    before_action :authenticate_employee!

    def show
    end

    def edit
    end

    def update
        if @employee.update(employee_params())
            flash[:notice] = 'Perfil atualizado!'
            redirect_to employees_backoffice_employee_path(@employee)
        else
            render :edit
        end
    end

    private
    def employee_find
        @employee = Employee.find(params[:id])
    end

    def employee_params
        params.require(:employee).permit(:email, :name, :avatar)
    end
end
