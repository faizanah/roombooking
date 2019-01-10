module Admin
  class CamdramSocietiesController < DashboardController
    def index
      @camdram_societies = Roombooking::CamdramAPI.client.get_societies
    end

    def create
      id = params[:id].to_i
      unless id == 0
        roombooking_show = CamdramSociety.create_from_id(id)
      end
      redirect_to action: :index
    end

    def update
      @camdram_society = CamdramSociety.find(params[:id])
      @camdram_society.attributes = camdram_society_params
      if @camdram_society.valid?
        @camdram_society.save
      end
      if request.xhr?
        # Request is AJAX.
        head :no_content
      else
        redirect_to action: :index
      end
    end

    private

    def camdram_society_params
      params.require(:camdram_society).permit(:max_meetings, :active)
    end
  end
end
