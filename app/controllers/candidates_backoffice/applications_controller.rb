class CandidatesBackoffice::ApplicationsController < CandidatesBackofficeController
    before_action :authenticate_candidate!

    def index
        @applications = Application.where(candidate_id: current_candidate.id)
    end

    def new
        @application = Application.new
    end

    def create
        application = Application.new application_params
        if application.save
            flash[:notice] = 'Candidatura enviada!'
            redirect_to candidates_backoffice_applications_path
        end

    end

    private
    def application_params
        params.require(:application).permit(:job_id, :candidate_id)
    end
end