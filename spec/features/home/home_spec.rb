require 'rails_helper'

describe 'Sections:show', type: :feature do
  let!(:event) { create(:event, :with_sections, beginning_date: Time.zone.now, end_date: Time.zone.now + 2.days) }

  before(:each) do
    visit root_path
  end

  context 'show section on index' do
    it 'show' do
      event.sections.each_with_index do |section, i|
        expect(page).to have_content(section.title)
        #expect(page).to have_content(html(section.content))
        #expect(icon_class).to eq(section.icon.sub(/fas|far|fab/, ''))
      end
    end
  end

  context 'icons with links' do
    it do
      event.sections.each_with_index do |section, i|
        expect(page).to have_link((section.id))
      end
    end
  end
end
