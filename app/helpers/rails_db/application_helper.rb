module RailsDb
  module ApplicationHelper
    include ::FontAwesome::Rails::IconHelper

    def rails_db_tables
      ActiveRecord::Base.connection.tables.sort - ['schema_migrations']
    end

    def title(str)
      content_for :title do
        raw("#{str}"[0].upcase + "#{str}"[1..-1])
      end
    end

    def paginate_table_entries(entries)
      return if entries.total_pages == 1
      prev_page_text = "#{fa_icon('arrow-left')} Previous".html_safe
      next_page_text = "Next #{fa_icon('arrow-right')}".html_safe

      html = '<div class="pagination">'
      if entries.previous_page
        html << link_to(prev_page_text, params.merge({:page => entries.previous_page}), {class: 'page'})
      end
      html << "#{page_links_for_pagination(entries)}"
      if entries.next_page
        html << link_to(next_page_text, params.merge({:page => entries.next_page}), {class: 'page'})
      end
      html << '</div>'

      sanitize(html)
    end

    private

    def page_links_for_pagination(entries)
      pages = pages_for_pagination(entries)
      links = []

      pages.each_with_index do |page,index|
        if page == entries.current_page
          links << content_tag(:b, page, {class: 'page current'})
        else
          links << link_to(page, params.merge({:page => page}), {class: 'page'})
        end
        links << " ... " if page != pages.last && (page + 1) != pages[index+1]
      end

      links.join(' ')
    end

    def pages_for_pagination(entries)
      last_page    = entries.total_pages
      current_page = entries.current_page

      pages = if last_page > 10
        [1, 2, 3] +
        (current_page-2..current_page+2).to_a +
        (last_page-2..last_page).to_a
      else
        (1..last_page).to_a
      end

      pages.uniq.select { |p| p > 0 && p <= last_page }
    end

  end
end
