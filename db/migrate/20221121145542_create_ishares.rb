class CreateIshares < ActiveRecord::Migration[5.2]
  def change
    create_table :ishares do |t|
      t.column "issue_id", :integer, :default => 0, :null => false, comment: "Issue ID of redmine"
      t.column "user_id", :integer, :default => 0, :null => false, comment: "User ID of redmine"
      t.column "created_on", :timestamp, comment: "Когда совершили данное действо в Redmine"
      t.column "expired", :timestamp, comment: "Когда перестает действовать ссылка"
      t.column "password", :string, :default => "", :null => false, comment: "Password hash"
      t.column "note", :string, :default => "", :null => false, comment: "Short notes for share link"
      t.column "cnt_igi", :integer, :default => 0, :null => false, comment: "Сколько раз ввели пароль"
    end
    add_index :ishares, [:issue_id, :expired], :name => :ishare_index
  end
end
