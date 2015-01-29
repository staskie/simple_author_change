require 'issue'

module SimpleAuthorChange
  module IssuePatch
    def self.included(base)
      base.class_eval do
        safe_attributes :author_id
      end
    end
  end
end
