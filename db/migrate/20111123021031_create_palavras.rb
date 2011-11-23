class CreatePalavras < ActiveRecord::Migration
  def change
    create_table :palavras do |t|
      t.string :word

      t.timestamps
    end
  end
end
