require 'project'

module SimpleAuthorChange
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      MinQueryLength = 3

      def potential_authors(query)
        # Trigger search only when having more than 2 characters for a query
        if query.length >= MinQueryLength
          # Limit the number of queries required to work out members of a project (including anonymous user)
          # that are permitted to create issues for a given project and return ActiveModel::Relation
          role_ids           = Role.all.select { |r| r.has_permission?(:add_issues) }.map(&:id)
          member_ids         = Member.includes(:roles).where('roles.id in (?)', role_ids).map(&:id)
          roles_user_ids     = Member.includes(:user).where(id: member_ids).map(&:user).compact.map(&:id)
          permitted_user_ids = users.where(id: roles_user_ids).map(&:id)

          if User.anonymous.allowed_to?(:add_issues, self)
            permitted_user_ids << User.anonymous.id
          end

          User.where(id: permitted_user_ids).like(query).sorted
        else
          # Return empty ActiveRecord::Relation
          User.where('1=2')
        end
      end
    end
  end
end
