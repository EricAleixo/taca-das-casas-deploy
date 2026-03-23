class CreateTurmas < ActiveRecord::Migration[7.2]
  def change
    create_table :turmas do |t|
      t.string :nome

      t.timestamps
    end
  end
end
