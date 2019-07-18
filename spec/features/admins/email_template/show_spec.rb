require 'rails_helper'

describe 'Section:show', type: :feature do
  include ActionView::Helpers::UrlHelper

  let(:admin) { create(:admin) }
  let(:email_template) { create(:email_template) }

  before(:each) do
    login_as(admin, scope: :admin)
    visit admins_email_template_path(email_template)
  end

  context 'with data' do
    it 'showed' do
      within('.card-body') do
        expect(page).to have_content(email_template.name)
        expect(page).to have_content(email_template.subject)
        expect(page).to have_content(email_template.update_link_title)
        expect(page).to have_content(email_template.unregister_link_title)

        update_link = link_to email_template.update_link_title, admins_email_templates_path
        unregister_link = link_to email_template.unregister_link_title, admins_email_templates_path
        content = ERB::Util.html_escape email_template.get_replaced_content(update_link,
                                                                            unregister_link)
                                                      .html_safe
        expect(page.body).to include(content)
      end
    end
  end
end
