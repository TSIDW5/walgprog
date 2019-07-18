require 'rails_helper'

describe 'Admins::EmailTemplate::update', type: :feature do
  let(:resource_name) { EmailTemplate.model_name.human }
  let(:admin) { create(:admin) }
  let!(:email_template) { create(:email_template) }

  before(:each) do
    login_as(admin, scope: :admin)
    visit edit_admins_email_template_path(email_template)
  end

  context 'when render edit' do
    it 'filled the fields' do
      expect(page).to have_field('email_template_subject',
                                 with: email_template.subject)
      expect(page).to have_field('email_template_update_link_title',
                                 with: email_template.update_link_title)
      expect(page).to have_field('email_template_unregister_link_title',
                                 with: email_template.unregister_link_title)
      expect(page).to have_field('email_template_content_markdown',
                                 with: email_template.content_markdown,
                                 visible: false)
    end
  end

  context 'when data is valid' do
    it 'update without buttons title' do
      attributes = attributes_for(:email_template)

      fill_in 'email_template_subject', with: attributes[:subject]

      fill_in 'email_template_content_markdown', with: attributes[:content_markdown], visible: false
      click_button

      expect(page).to have_current_path admins_email_templates_path
      success_message = I18n.t('flash.actions.update.m', resource_name: resource_name)
      expect(page).to have_flash(:success, text: success_message)
    end

    it 'update with buttons title' do
      attributes = attributes_for(:email_template)

      fill_in 'email_template_subject', with: attributes[:subject]

      fill_in 'email_template_content_markdown', with: attributes[:content_markdown], visible: false
      fill_in 'email_template_update_link_title', with: attributes[:update_link_title]
      fill_in 'email_template_unregister_link_title', with: attributes[:unregister_link_title]
      click_button

      expect(page).to have_current_path admins_email_templates_path
      success_message = I18n.t('flash.actions.update.m', resource_name: resource_name)
      expect(page).to have_flash(:success, text: success_message)
    end
  end

  context 'when data are not valid', js: true do
    it 'show errors' do
      content_md = "WAlgProg.simpleMDEInstances['email_template_content_markdown'].value('')"
      page.execute_script(content_md)

      fill_in 'email_template_subject', with: ''

      sleep 2
      click_button

      expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
      message_blank_error = I18n.t('errors.messages.blank')
      expect(page).to have_message(message_blank_error, in: 'div.email_template_content_markdown')
      expect(page).to have_message(message_blank_error, in: 'div.email_template_subject')
    end
  end
end
