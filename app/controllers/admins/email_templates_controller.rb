class Admins::EmailTemplatesController < Admins::BaseController
  include ActionView::Helpers::UrlHelper

  add_breadcrumb I18n.t('breadcrumbs.action.index',
                        resource_name: I18n.t('activerecord.models.email_template.other')),
                 :admins_email_templates_path, only: [:index, :edit, :update, :show]

  add_breadcrumb I18n.t('breadcrumbs.action.edit',
                        resource_name: I18n.t('activerecord.models.email_template.one')),
                 :edit_admins_email_template_path, only: [:edit, :update]

  add_breadcrumb I18n.t('breadcrumbs.action.show',
                        resource_name: I18n.t('activerecord.models.email_template.one')),
                 :admins_email_template_path, only: [:show]

  before_action :set_template, only: [:edit, :update, :show]
  before_action :set_resource_name, only: [:update]

  def index
    @templates = EmailTemplate.order(name: :asc)
  end

  def show
    @name = I18n.t('helpers.user')
    @update_link = link_to @template.update_link_title, admins_email_templates_path
    @unregister_link = link_to @template.unregister_link_title, admins_email_templates_path
  end

  def edit; end

  def update
    options = {
      redirect_to: :edit,
      path: admins_email_templates_path,
      action: 'flash.actions.update.m',
      model_name: @resource_name
    }
    action_success? @template.update(template_params), options
  end

  protected

  def template_params
    params.require(:email_template).permit(:subject,
                                           :content_markdown,
                                           :update_link_title,
                                           :unregister_link_title)
  end

  def set_resource_name
    @resource_name = EmailTemplate.model_name.human
  end

  def set_template
    @template = EmailTemplate.find(params[:id])
  end
end
