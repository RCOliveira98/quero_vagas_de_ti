class EmployeesBackoffice::ProposalsController < EmployeesBackofficeController
    before_action :authenticate_employee!

    def new
        @proposal = Proposal.new
    end

    def create
        @proposal = Proposal.new proposal_params()
        set_employee()
        set_job_application()

        if @proposal.save
            flash[:notice] = 'Proposta de emprego enviada!'
            redirect_to employees_backoffice_applications_path
        else
            render :new
        end
    end

    private
    def proposal_params
        params.require(:proposal).permit(:message, :start_date, :salary_proposal)
    end

    def set_employee
        @proposal.employee = current_employee
    end

    def set_job_application
        @proposal.application = Application.find(params[:application])
    end
end