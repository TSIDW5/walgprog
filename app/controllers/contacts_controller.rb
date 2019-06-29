class ContactsController < ApplicationController
  before_action :set_contact, only: [:unregister, :update, :edit, :confirm_unregister]

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params_contact)
    if !Contact.exists?(:email => params[:email])
    @contact.generate_token(:unregister_token)
    @contact.generate_token(:update_data_token)
    @contact.update_data_send_at = Time.zone.now
    if @contact.save
      # ContactMailer.with(contacts: @contact).welcome_email.deliver
      @contact.send_welcome_email
      flash[:success] = I18n.t('flash.actions.create.m',
        resource_name: I18n.t('activerecord.models.contact.one'))
        redirect_to contacts_path
      else
        flash.now[:error] = I18n.t('flash.actions.errors')
        render :new
    end
    else
      @contact.generate_token(:update_data_token)
      @contact.update_data_send_at = Time.zone.now
      @contact.send_self_update
      redirect_to contacts_path
  end
end

  def edit
    if @contact.valid_token(params)
      render :edit
    else
      flash[:error] = I18n.t('flash.actions.errors')
    end
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

  def confirm_unregister; end

  def unregistered; end

  def updated; end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def params_contact
    params.require(:contact).permit(:name, :email, :phone, :institution_id)
  end
end
