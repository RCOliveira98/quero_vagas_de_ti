class CandidatesBackoffice::ProposalsController < CandidatesBackofficeController
    before_action :authenticate_candidate!

    def index
        @proposals = []
        applications = Application.where(candidate_id: current_candidate.id)
        applications.each do |application|
            @proposals.push application.proposal if application.proposal
        end
    end
end