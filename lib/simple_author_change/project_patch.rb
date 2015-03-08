require 'project'

module SimpleAuthorChange
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def potential_authors(query)
        # Limit the number of queries required to work out members of a project (including anonymous user)
        # that are permitted to create issues for a given project and return ActiveModel::Relation
        roles = Role.all.select { |r| r.has_permission?(:add_issues) }
        roles_user_ids = roles.map { |role| role.members.includes(:user) }.flatten.map(&:user).uniq.compact.map(&:id)

        permitted_user_ids = users.where(id: roles_user_ids).map(&:id)

        if User.anonymous.allowed_to?(:add_issues, self)
          permitted_user_ids << User.anonymous.id
        end

        User.where(id: permitted_user_ids).like(query).sorted
      end
    end
  end
end
