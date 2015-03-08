class IssueAuthorsController < ApplicationController
  before_filter :find_project
  before_filter :authorize

  unloadable

  def new
  end

  def autocomplete
    @users = @project.potential_authors(params[:q])
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end
