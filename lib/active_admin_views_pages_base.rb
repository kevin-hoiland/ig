class ActiveAdmin::Views::Pages::Base < Arbre::HTML::Document

  private

  # Renders the content for the admin footer
  def build_footer
    div :id => "footer" do
      # para "Copyright &copy; #{Date.today.year.to_s} #{link_to('IntlGum.com', 'http://intlgum.com')}. Powered by #{link_to('Active Admin', 'http://www.activeadmin.info')} #{ActiveAdmin::VERSION}".html_safe
        para "Proprietary and Confidential</br>Copyright &copy; #{Date.today.year.to_s} International Gum Inc.</br>".html_safe
    end
  end

end