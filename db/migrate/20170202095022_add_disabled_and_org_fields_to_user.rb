class AddDisabledAndOrgFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :disabled, :boolean, default: false
    add_column :users, :organisation_content_id, :string
  end
end
