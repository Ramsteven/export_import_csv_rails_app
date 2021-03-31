class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add attribute, (options[:message] || "is not an email")
    end
  end
end


class Employee < ApplicationRecord
  validates :nombres, :apellidos, :telefono, :email, :cargo, :salario, :departamento, presence: true
  validates :telefono, numericality: { only_integer: true }, length: {is: 11}
  validates :email, email: true, uniqueness: {case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, length: { maximum: 105 }, uniqueness: {case_sensitive: false }, format: { with: VALID_EMAIL_REGEX}
  
  def self.to_csv
    attributes = %w{id nombres apellidos telefono email cargo salario departamento }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def self.my_import(file)
      employees = []
      value = Employee.last.present? ? Employee.last.id : 0
      CSV.foreach(file.path, headers: true) do |row|  
        if email_validate(employees, row[4])
          next 
        end
        row[0] = value+=1
        employees << Employee.new(row.to_h) 
      end
      import(employees, validate: true, validate_uniqueness: true)
      #Employee.import employees, recursive: true, on_duplicate_key_ignore: { columns: [:email] } 
  end

  def name
    "#{first_name} #{last_name}"
  end
 
  private
  #function that check employees array and model Employee 
  #for discard employees with repetead email
  def self.email_validate(employees, current_email) 
    i=0
    while i <= employees.length
      begin
        if vali=employees[i][:email] == current_email
          return true
        end
      rescue => e
      end
      
      if Employee.where(email: current_email).present?
        return true
      end
      i+=1
    end 
    false
  end
end
