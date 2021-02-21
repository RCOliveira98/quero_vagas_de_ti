class CandidatesBackoffice::CandidatesController < CandidatesBackofficeController
    before_action :authenticate_candidate!

    def profile
        @candidate = Candidate.find(params[:id])
        unless @candidate.profile?
            @candidate.candidate_profile = @candidate.build_profile
        end
    end
end