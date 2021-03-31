class EmployeesController < ApplicationController
 
  def index
    @employees = Employee.all
  end


  def export_csv
     @employees = Employee.all
     respond_to do |format|
      format.html
      format.csv { send_data @employees.to_csv, filename: "employees-#{Date.today}.csv",  type: 'text/csv; charset=utf-8' }
    end
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(set_params)
    @employee.id = Employee.last.id + 1
    if @employee.save
      flash[:notice] = "Usuario #{ @employee.email} creado "
      redirect_to root_path
    else
      render 'new'
    end
  end

  def import
    begin
      Employee.my_import(params[:file])
    rescue => exception
      message = exception.message
      flash[:alert] = "Something wrong happened with the file #{message}"
    end
    redirect_to root_url
  end

  private

  def set_params
    params.require(:employee).permit(:nombres,:email,:apellidos,:cargo, :telefono, :salario, :departamento)
  end

end
