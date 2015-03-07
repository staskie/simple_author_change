require 'redmine'

Redmine::Plugin.register :simple_author_change do
  name 'Simple Author Change plugin'
  author 'Dominik Staskiewicz'
  description 'This is a simplest way of changing an author I can think of'
  version '0.0.3'
  url 'http://dapplication.com'
  author_url 'http://dapplication.com'

  project_module :simple_author_change do
    permission :change_issue_author, {issue_authors: [:new, :autocomplete]}
  end
end

require_relative 'lib/simple_author_change/issue_patch'
require_relative 'lib/simple_author_change/hooks'

Rails.configuration.to_prepare do
  Issue.send(:include, SimpleAuthorChange::IssuePatch)
end
