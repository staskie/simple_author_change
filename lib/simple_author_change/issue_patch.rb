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
    end
  end
end
