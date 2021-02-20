class CandidatesBackoffice::HomeController < CandidatesBackofficeController
    before_action :authenticate_employee!

    def index
    end
end