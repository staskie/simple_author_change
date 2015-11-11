require 'project'

module SimpleAuthorChange
  module ProjectPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      MIN_QUERY_LENGTH = 3

      def potential_authors(query)
        # Trigger search only when having more than 2 characters for a query
        if query.length >= MIN_QUERY_LENGTH
          User.where(id: permitted_user_ids).like(query).sorted
        else
          User.where(nil)
        end
      end

      private

      def role_ids
        Role.all.select { |r| r.has_permission?(:add_issues) }.map(&:id)
      end

      def member_ids
        Member.includes(:member_roles).where('member_roles.role_id in (?)',role_ids)
          .references(:member_roles).map(&:id)
      end

      def roles_user_ids
        Member.includes(:user).where(id: member_ids)
          .map(&:user).compact.map(&:id)
      end

      def permitted_user_ids
        _permitted_user_ids = users.where(id: roles_user_ids).map(&:id)
        _permitted_user_ids << User.anonymous.id if include_anonymous_user?
        _permitted_user_ids
      end

      def include_anonymous_user?
        User.anonymous.allowed_to?(:add_issues, self)
      end
    end
  end
end
