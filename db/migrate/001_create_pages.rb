class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :position
      t.string  :title
      t.text    :body
      t.timestamps
    end
    add_index :pages, :position
    Page.create({
      :position => 1,
      :title => "Home",
      :body  => "This would be the perfect place to put your 'home page' info."
    })
  end

  def self.down
    drop_table :pages
  end
end
