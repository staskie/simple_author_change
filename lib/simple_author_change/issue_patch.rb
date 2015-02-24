require 'issue'

module SimpleAuthorChange
  module IssuePatch
    def self.included(base)
      base.class_eval do
        safe_attributes :author_id
      end

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def potential_authors
        (project.members.map(&:user) + [User.anonymous]).
          uniq.select { |user| user.allowed_to?(:add_issues, project)}
      end
    end
  end
end
