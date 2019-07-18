Admin.create_with(name: 'Administrador', password: '123456', user_type: 'A')
     .find_or_create_by!(email: 'admin@admin.com')

scholarity = [
  { name: 'Ensino médio completo', abbr: 'Ensino m.' },
  { name: 'Graduado', abbr: 'Grad.' },
  { name: 'Especialista', abbr: 'Esp.' },
  { name: 'Mestre', abbr: 'Me.' },
  { name: 'Doutor', abbr: 'Dr.' },
  { name: 'Doutora', abbr: 'Dra.' }
]

scholarity.each do |title|
  Scholarity.find_or_create_by!(name: title[:name], abbr: title[:abbr])
end

email_templates = [
  { name: I18n.t('email_template.welcome_mail'),
    subject: I18n.t('mail.welcome_email.subject'),
    update_link_title: I18n.t('email_template.update_contact'),
    unregister_link_title: I18n.t('email_template.unregister'),
    content_markdown: Faker::Markdown.sandwich(6, 3) },
  { name: I18n.t('email_template.update_contact'),
    subject: I18n.t('mail.updated.subject'),
    update_link_title: I18n.t('email_template.update_contact'),
    unregister_link_title: I18n.t('email_template.unregister'),
    content_markdown: Faker::Markdown.sandwich(6, 3) },
  { name: I18n.t('email_template.unregister'),
    subject: I18n.t('mail.unregistered.subject'),
    update_link_title: I18n.t('email_template.update_contact'),
    unregister_link_title: I18n.t('email_template.unregister'),
    content_markdown: Faker::Markdown.sandwich(6, 3) }
]

email_templates.each do |template|
  EmailTemplate.create_with(name: template[:name],
                            content_markdown: template[:content_markdown],
                            subject: template[:subject])
               .find_or_create_by!(name: template[:name])
end
