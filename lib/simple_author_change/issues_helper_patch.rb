module SimpleAuthorChange
  module IssuesHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def potential_author_name(issue, params)
        if params[:issue] && params[:issue][:author_id]
          User.find(params[:issue][:author_id])
        else
          issue.author
        end
      end
    end
  end
end
