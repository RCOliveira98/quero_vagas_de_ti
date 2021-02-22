class CandidatesBackoffice::JobsController < CandidatesBackofficeController
    before_action :authenticate_candidate!
    def show
        @job = Job.find(params[:id])
        @application = Application.new
    end
end