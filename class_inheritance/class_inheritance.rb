require 'byebug'

class Employee
  attr_reader :name, :title, :salary, :boss
  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  attr_reader :employees
  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end
  def bonus(multiplier)
    # @employees.reduce {|sum, employee| sum + employee.salary} * multiplier
    total = @employees.reduce(0) do |sum, employee|
      if employee.is_a?(Manager)
        sum + employee.bonus(1) + employee.salary
      else
        sum + employee.salary
      end
    end
    total * multiplier
  end
end

if __FILE__ == $PROGRAM_NAME
david  = Employee.new("david","TA", 10_000,  "darren")
shawna = Employee.new("shawna","TA", 12_000, "darren")
darren = Manager.new("darren","TA Manager", 78_000, nil, [david, shawna])
ned    = Manager.new("Ned", "Founder", 1_000_000, nil, [darren])

p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
end
