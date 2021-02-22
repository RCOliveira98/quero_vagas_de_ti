class CandidatesBackoffice::CandidatesController < CandidatesBackofficeController
    before_action :authenticate_candidate!
    before_action :candidate_find, only: %i[edit show update]
    before_action :make_candidate_profile, only: %i[edit show update]

    def show
    end

    def edit
    end

    def update
        if @candidate.update(params_candidate)
            flash[:notice]= 'Perfil atualizado com sucesso'
            redirect_to candidates_backoffice_candidate_path(@candidate)
        else
            render :edit
        end
    end

    private
    def candidate_find
        @candidate = Candidate.find(params[:id])
    end

    def params_candidate
        params.require(:candidate).permit(:email, :password, candidate_profile_attributes: [
            :id,
            :cpf,
            :candidate_id,
            :name,
            :country,
            :state,
            :zip_code,
            :neighborhood,
            :city,
            :logradouro,
            :biography,
            :phone
        ])
    end

    def make_candidate_profile
        @candidate.build_profile
    end
end