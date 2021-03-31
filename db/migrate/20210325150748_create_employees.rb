class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.string :nombres
      t.string :apellidos
      t.integer :telefono, null: false, limit: 8
      t.string :email
      t.string :cargo
      t.decimal :salario
      t.string :departamento

      t.timestamps
    end
  end
end
