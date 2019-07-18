require 'rails_helper'

RSpec.describe EmailTemplate, type: :model do
  include ActionView::Helpers::UrlHelper

  describe 'validates' do
    [:name, :subject, :content_markdown].each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end

  describe 'markdown' do
    it 'parse to html' do
      email_template = create(:email_template)
      html = <<-HTML.chomp.strip_heredoc
        <h1>Effugiam erit cinerem tenuere concurrere</h1>

        <h2>Mihi persequar et trementi muris constant tibique</h2>

        <p>Lorem markdownum, abstulerunt preces prima. Ripas et concipit <strong>genuit</strong>.</p>

      HTML

      expect(email_template.content).to eql(html)
    end

    context 'with content' do
      let!(:email_template) { create(:email_template, :with_markdown_variables) }

      it 'without replaced variables' do
        update_link = link_to email_template.update_link_title, '/'
        unregister_link = link_to email_template.unregister_link_title, '/'

        content = email_template.get_replaced_content(update_link, unregister_link)

        expect(content).to eql(content)
      end

      it 'with replaced variables' do
        update_link = link_to email_template.update_link_title, '/'
        unregister_link = link_to email_template.unregister_link_title, '/'

        content = email_template.get_replaced_content(update_link, unregister_link)

        expect(content).to include(I18n.t('helpers.user'))
        expect(content).to include(update_link)
        expect(content).to include(unregister_link)
      end
    end
  end
end
