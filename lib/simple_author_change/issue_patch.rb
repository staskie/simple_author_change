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
      def potential_author_name(args)
        if args[:issue] && args[:issue][:author_id]
          User.find(params[:issue][:author_id])
        else
          self.author
        end
      end
    end
  end
end
