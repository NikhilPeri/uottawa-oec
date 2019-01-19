include TwilioHelper
include ActionView::Helpers::NumberHelper

class PatientsController < ApplicationController

  def create
    @patient = Patient.new(patient_params)
    @patient.save!
    body = <<-EOF
    Hey #{@patient.first_name},
    My name is WaitER, and I will let you know when you should expect to be seen by a doctor.
    Just text #{TwilioHelper::LEAVE_COMMAND} if you no longer need assistance
    EOF

    begin
      TwilioHelper.send_message(
        to: @patient.phone_number,
        body: body
      )
    rescue
      flash[:notice] = "Patient could not be reached at #{number_to_phone(@patient.phone_number)}"
    end

    flash[:success] = 'Patient created'
    redirect_to action: :index
  end

  def show
    @patient = Patient.find(params[:id])
    render 'edit'
  end

  def new
    @patient = Patient.new
  end

  def edit
    @patient = Patient.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    if @patient.update_attributes(patient_params)
      flash[:success] = "Account Successfully Updated!"
      render 'edit'
    else
      flash[:errors]
      render 'edit'
    end
  end

  def index
    @patients = Patient.all.order(:aasm_state).paginate(page: params[:page])
  end

  def complete
    @patient = Patient.find(params[:patient_id])
    @patient.complete! unless @patient.completed?
    flash[:success]= 'Appointment Completed'
    redirect_to action: :index
  end

  private

  def patient_params
    params \
      .require(:patient) \
      .permit(:first_name, :last_name, :phone_number) \
      .merge(data: params[:data].permit!.to_h).permit!
  end
end
