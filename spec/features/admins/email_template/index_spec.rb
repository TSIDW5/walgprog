require 'rails_helper'

describe 'Admins::EmailTemplate::index', type: :feature do
  let(:admin) { create(:admin) }
  let!(:email_templates) { create_list(:email_template, 2, :welcome) }

  before(:each) do
    login_as(admin, scope: :admin)
    visit admins_email_templates_path
  end

  context 'with data' do
    it 'showed' do
      within('table tbody') do
        email_templates.each_with_index do |email_template, i|
          within("tr:nth-child(#{i + 1})") do
            expect(page).to have_content(email_template.name)
            expect(page).to have_content(email_template.subject)

            expect(page).to have_link(href: admins_email_template_path(email_template))
            expect(page).to have_link(href: edit_admins_email_template_path(email_template))
          end
        end
      end
    end
  end
end
