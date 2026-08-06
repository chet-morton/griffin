class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update]

  def index
    @companies = Company.includes(:job_postings).order(updated_at: :desc)
  end

  def show
    @active_jobs = @company.job_postings.includes(:candidate_applications, :skill_requirements)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to company_path(@company), notice: "Company created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :industry, :website, :tier, :notes)
  end
end
