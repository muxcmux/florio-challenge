module Api
  module V1
    class PatientsController < ApplicationController
      skip_before_action :authenticate_with_api_token!, only: :create

      def create
        @patient = Patient.new(patient_params)

        raise ApiError, @patient.errors unless @patient.valid?

        @patient.save
        render :show, status: :created
      end

      def adherence_score
        @score = AdherenceScore.new(@current_patient)
      end

      private

      def patient_params
        params.require(:patient).permit(:schedule_days)
      end
    end
  end
end
