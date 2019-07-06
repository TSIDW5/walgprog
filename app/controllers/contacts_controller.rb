class ContactsController < ApplicationController
  before_action :set_contact, only: [:unregister, :update, :edit, :confirm_unregister]
  before_action :set_new_contact, only: :create

  layout 'layouts/contact'

  def new
    @contact = Contact.new
  end

  def create
    if !@contact.exist_email(params_contact)
      email_no_exists
    else
      email_exists
    end
  end

  def edit
    return unless @contact.valid_token(params)
    flash[:error] = I18n.t('activerecord.models.contact.token_expired')
  end

def unregister
  if @contact.update_by_token_to_unregister(params)
    render :unregistered
  else
    redirect_to admins_institution_path
  end
end

def update
  render @contact.update_by_token(params, params_contact)
end

def save_sucess
  flash[:success] = I18n.t('flash.actions.create.m',
                           resource_name: I18n.t('activerecord.models.contact.one'))
  redirect_to contacts_path
end

def confirm_unregister;
end

def unregistered;
end

def updated;
end

private

def generate_tokens
  @contact.generate_token(:unregister_token)
  @contact.generate_token(:update_data_token)
  @contact.update_data_send_at = Time.zone.now
end

def set_new_contact
  @contact = Contact.new(params_contact)
end

def set_contact
  @contact = Contact.find(params[:id])
end

def set_contact_by_email
  @contact = Contact.where(email: params_contact[:email]).first
end

def params_contact
  params.require(:contact).permit(:name, :email, :phone, :institution_id)
end

def email_exists
  set_contact_by_email
  generate_tokens
  @contact.save
  @contact.send_self_update
  render :update_email
end

def email_no_exists
  generate_tokens
  if @contact.save
    save_sucess
    @contact.send_welcome_email
  else
    flash.now[:error] = I18n.t('flash.actions.errors')
    render :new
  end
end

end
