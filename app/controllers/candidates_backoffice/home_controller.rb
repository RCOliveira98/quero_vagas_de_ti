class CandidatesBackoffice::HomeController < CandidatesBackofficeController
    before_action :authenticate_candidate!

    def index
    end
end