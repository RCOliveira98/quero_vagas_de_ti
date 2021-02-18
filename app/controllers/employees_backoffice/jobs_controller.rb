class EmployeesBackoffice::JobsController < EmployeesBackofficeController
    before_action :authenticate_employee!
    before_action :select_levels, only: %i[new]

    def index
        @jobs = Job.select_unexpired_jobs_for_a_company(current_employee.company_id)
    end

    def new
        @job = Job.new()
    end

    def create
        @job = Job.new(job_params())
        @job.employee_id = current_employee.id
        @job.company_id = current_employee.company_id

        if @job.save()
            flash[:notice] = 'Vaga de emprego cadastrada com sucesso'
            redirect_to employees_backoffice_jobs_path()
        else
            select_levels()
            render :new
        end
    end

    private

    def select_levels
        @levels = Job.levels
    end

    def job_params
        params.require(:job).permit(:title,
                                    :description,
                                    :level,
                                    :lowest_salary,
                                    :highest_salary,
                                    :quantity,
                                    :deadline_for_registration,
                                    :company_id,
                                    :employee_id,
                                    requirement_ids: []
                                )
    end
end
