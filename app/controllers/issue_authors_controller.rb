class IssueAuthorsController < ApplicationController
  before_filter :find_issue
  before_filter :authorize

  unloadable

  def new
  end

  def autocomplete
    @users = @issue.potential_authors(params[:q])
  end

  private

  def find_issue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  end

end
