module EmailTemplateContent
  include ActionView::Helpers::UrlHelper

  def generate_content(template, contact)
    @update_link = link_to template.update_link_title, contact_edit_url(contact,
                                                                        contact.update_token)
    @unregister_link = link_to template.unregister_link_title,
                               contact_unregister_confirmation_url(contact,
                                                                   contact.unregister_token)

    @content = template.get_replaced_content(@update_link, @unregister_link, contact.name)
  end
end
