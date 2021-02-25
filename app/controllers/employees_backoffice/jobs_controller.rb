class EmployeesBackoffice::JobsController < EmployeesBackofficeController
    before_action :authenticate_employee!
    before_action :select_levels, only: %i[new edit create]
    before_action :select_status, only: %i[new edit create]
    before_action :job_find, only: %i[edit update]

    def index
        @jobs = Job.select_unexpired_jobs_for_a_company(current_employee.company_id)
    end

    def show
        begin
            job_find()
        rescue => exception
            flash[:alert] = 'A vaga de trabalho que tentou acessar não existe!'
            redirect_to employees_backoffice_jobs_path
        end
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

    def edit
        unless @job.creator_of_the_same_company?(current_employee.company_id)
            flash[:alert] = 'As vagas de uma empresa só podem ser atualizadas por seus funcionários'
            redirect_to employees_backoffice_jobs_path
        end
    end

    def update
        if @job.update(job_params())
            flash[:notice] = 'Vaga de trabalho atualizada com sucesso'
            redirect_to employees_backoffice_jobs_path
        else
            select_levels()
            select_status()
            render :edit
        end
    end

    private

    def select_levels
        @levels = Job.levels
    end

    def select_status
        @statuses = Job.statuses
    end

    def job_params
        params.require(:job).permit(:title,
                                    :description,
                                    :level,
                                    :status,
                                    :lowest_salary,
                                    :highest_salary,
                                    :quantity,
                                    :deadline_for_registration,
                                    :company_id,
                                    :employee_id,
                                    requirement_ids: []
                                )
    end

    def job_find
        @job = Job.find(params[:id])
    end
end
