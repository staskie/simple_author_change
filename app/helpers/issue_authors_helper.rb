module IssueAuthorsHelper
  def render_potential_authors(scope, project)
    principal_count = scope.count
    principal_pages = Redmine::Pagination::Paginator.new principal_count, 100, params['page']
    principals = scope.offset(principal_pages.offset).limit(principal_pages.per_page).all

    s = content_tag('div', authors_radio_tags('issue[author_id]', principals))

    links = pagination_links_full(principal_pages, principal_count, :per_page_links => false) {|text, parameters, options|
      link_to text, autocomplete_project_issue_authors_path(project, parameters.merge(:q => params[:q], :format => 'js')), :remote => true
    }

    s + content_tag('p', links, :class => 'pagination')
  end

  def authors_radio_tags(name, users)
    s = ''
    s << '<table>'
    users.each do |user|
      s << '<tr>'
      s << "<td>#{ radio_button_tag name, user.id, false, id: nil}</td>"
      s << "<td class='potential_author_name'>#{h user}</td>"
      s << "<td>#{h user.mail}</td>"
      s << "<td>#{h user.login}</td>"
      s << '</tr>'
    end
    s << '</table>'
    s.html_safe
  end
end
