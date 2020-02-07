class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
      new_student = self.new  # self.new is the same as running Song.new
      new_student.id = row[0]
      new_student.name =  row[1]
      new_student.grade = row[2]
      new_student  
  end

  def self.all
        sql = <<-SQL
        SELECT * FROM students
    SQL

    result = []

    student_maker = DB[:conn].execute(sql)
    student_maker.each {|e| result << self.new_from_db(e)}
    return result
  end

  def self.find_by_name(input)
    # find the student in the database given a name
    # return a new instance of the Student class
            sql = <<-SQL
        SELECT * FROM students where name = ?
    SQL

    student_maker = DB[:conn].execute(sql, input)

    return self.new_from_db(student_maker[0])
  end

  def self.all_students_in_grade_9
        sql = <<-SQL
        SELECT * FROM students where grade = 9
    SQL

    result = []

    student_maker = DB[:conn].execute(sql)
    student_maker.each {|e| result << self.new_from_db(e)}
    return result
  end

  def self.all_students_in_grade_X(xgrade)
        sql = <<-SQL
        SELECT * FROM students where grade = ?
    SQL

    result = []

    student_maker = DB[:conn].execute(sql, xgrade)
    student_maker.each {|e| result << self.new_from_db(e)}
    return result
  end

  def self.students_below_12th_grade
        sql = <<-SQL
        SELECT * FROM students where grade < 12
    SQL

    result = []

    student_maker = DB[:conn].execute(sql)
    student_maker.each {|e| result << self.new_from_db(e)}
    return result
  end

  def self.first_X_students_in_grade_10(xstudents)
        sql = <<-SQL
        SELECT * FROM students where grade = 10
    SQL

    result = []

    student_maker = DB[:conn].execute(sql)
    student_maker.first(xstudents).each {|e| result << self.new_from_db(e)}
    return result
  end

  def self.first_student_in_grade_10
        sql = <<-SQL
        SELECT * FROM students where grade = 10 Limit 1
    SQL

    result = []

    student_maker = DB[:conn].execute(sql)
    return self.new_from_db(student_maker[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
