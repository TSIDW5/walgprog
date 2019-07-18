class ContactMailer < ApplicationMailer
  include EmailTemplateContent

  def welcome
    send_mail_with_custom_content I18n.t('email_template.welcome_mail')
  end

  def confirmation
    @contact = params[:contact]
    mail(to: @contact.email_with_name, subject: I18n.t('mail.confirmation.subject'))
  end

  def update
    @contact = params[:contact]
    mail(to: @contact.email_with_name, subject: I18n.t('mail.update.subject'))
  end

  def updated
    send_mail_with_custom_content I18n.t('email_template.update_contact')
  end

  private

  def send_mail_with_custom_content(template_name)
    @contact = params[:contact]
    @template = EmailTemplate.find_by name: template_name
    @content = generate_content(@template, @contact)

    mail(to: @contact.email_with_name, subject: @template.subject)
  end
end

# settings app rails
# action mailer template define by user
