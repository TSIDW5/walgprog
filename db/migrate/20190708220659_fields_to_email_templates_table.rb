class FieldsToEmailTemplatesTable < ActiveRecord::Migration[5.2]
  def change
    change_table :email_templates, bulk: true do |t|
      t.string :update_link_title, null: true
      t.string :unregister_link_title, null: true
    end
  end
end
