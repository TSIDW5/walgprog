require 'rails_helper'

describe 'Admins::EmailTemplate::Breadcrumbs', type: :feature do
  let(:admin) { create(:admin) }
  let(:resource_name) { EmailTemplate.model_name.human }
  let(:resource_name_plural) { EmailTemplate.model_name.human count: 2 }

  before(:each) do
    login_as(admin, scope: :admin)
  end

  context 'when index' do
    let(:breadcrumbs) do
      [
        { text: text_for_home, path: admins_root_path },
        { text: text_for_index, path: admins_email_templates_path }
      ]
    end

    it 'show breadcrumbs' do
      visit admins_email_templates_path
      expect(page).to have_breadcrumbs(breadcrumbs, in: 'ol.breadcrumb', last: :text)
    end
  end

  context 'when edit' do
    let!(:email_template) { create(:email_template, :welcome) }
    let(:breadcrumbs) do
      [
        { text: text_for_home, path: admins_root_path },
        { text: text_for_index, path: admins_email_templates_path },
        { text: text_for_edit, path: edit_admins_email_template_path(email_template) }
      ]
    end

    before(:each) do
      visit edit_admins_email_template_path(email_template)
    end

    it 'show breadcrumbs on edit' do
      expect(page).to have_breadcrumbs(breadcrumbs, in: 'ol.breadcrumb', last: :text)
    end

    it 'show breadcrumbs on update' do
      fill_in 'email_template_subject', with: ''
      click_button

      expect(page).to have_breadcrumbs(breadcrumbs, in: 'ol.breadcrumb')
    end
  end
end
