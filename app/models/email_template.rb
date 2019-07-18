class EmailTemplate < ApplicationRecord
  before_save :md_to_html

  validates :name, :content_markdown, :subject, presence: true

  def get_replaced_content(update_link, unregister_link, name = I18n.t('helpers.user'))
    content.sub! '@nome', name
    content.sub! '@linkAtualizar', update_link
    content.sub! '@linkDesregistrar', unregister_link
    content
  end

  def md_to_html
    self.content = MarkdownRenders::HTML.render(content_markdown)
  end
end
