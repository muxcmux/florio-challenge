module Api
  module V1
    class InjectionsController < ApplicationController
      def index
        @injections = Injection.where(patient: @current_patient)
          .order(created_at: :desc)
          .limit(50)
      end

      def create
        @injection = @current_patient.injections.new(injection_params)

        raise ApiError, @injection.errors unless @injection.valid?

        @injection.save!
        render :show, status: :created
      end

      private

      def injection_params
        params.require(:injection).permit(:dose, :lot_number, :drug_name)
      end
    end
  end
end
