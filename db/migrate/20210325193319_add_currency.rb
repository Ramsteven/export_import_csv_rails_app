class AddCurrency < ActiveRecord::Migration[6.1]
  def change
    change_column_default :employees, :salario, precision: 8, scale: 2, from: nil, to: 0
  end
end
