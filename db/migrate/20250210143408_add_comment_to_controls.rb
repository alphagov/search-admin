class AddCommentToControls < ActiveRecord::Migration[8.0]
  def up
    add_column :controls, :comment, :text,
               comment: "A descriptive comment about why this control exists"

    execute "UPDATE controls SET comment = '' WHERE comment IS NULL"
    change_column_null :controls, :comment, false
  end

  def down
    remove_column :controls, :comment
  end
end
