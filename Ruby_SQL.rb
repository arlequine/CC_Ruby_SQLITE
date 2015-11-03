#interactuar con una base de datos desde código de Ruby
#Usando la base de datos SQLite y la gema sqlite3
require 'sqlite3'

class Chef
  attr_accessor :first_name, :last_name, :birthday, :email, :phone, :created_at, :updated_at

  def initialize(first_name, last_name, birthday, email, phone) 
    @first_name= first_name
    @last_name = last_name
    @birthday = birthday
    @email = email
    @phone = phone
  end
  #method to select all chef
  def self.all
    self.db
    #db = SQLite3::Database.new( "chefs.db" )

    db.execute( "select * from chefs" ) do |row|
      p row
    end

    db.close
  end
  #method select an unic chef 
  def self.where(value, data)
    self.db
    if name.is_a? String
      db.execute("select * from chefs where #{value} = '#{data}' or #{value} = ?", "#{data}" ) do |row|
        p row
      end
    else
      db.execute("select * from chefs where #{value} = #{data} or #{value} = ?", "#{data}" ) do |row|
        p row
      end
    end

    db.close
  end
  #Method delete a chef
  def self.delete(value, data)
    db.execute("delete from chefs where #{value} = #{data} or #{value} = ?", "#{data}")
  end
  #Method to create table
  def self.create_table
    Chef.db.execute(
      <<-SQL
      CREATE TABLE chefs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name VARCHAR(64) NOT NULL,
        last_name VARCHAR(64) NOT NULL,
        birthday DATE NOT NULL,
        email VARCHAR(64) NOT NULL,
        phone VARCHAR(64) NOT NULL,
        created_at DATETIME NOT NULL,
        updated_at DATETIME NOT NULL
        );
    SQL
    )
  end
  # method to save chef
  def save
    Chef.db.execute(
      <<-SQL
      INSERT INTO chefs
      (first_name, last_name, birthday, email, phone, created_at, updated_at)
      VALUES
      ('#{@first_name}', '#{@last_name}', '#{@birthday}', '#{@email}', '#{@phone}', DATETIME('now'), DATETIME('now'));
      SQL
      )
  end
  #Method to add 'chef'
  def self.seed
    Chef.db.execute(
      <<-SQL
      INSERT INTO chefs
      (first_name, last_name, birthday, email, phone, created_at, updated_at)
      VALUES
      ('Ferran', 'Adriá', '1985-02-09', 'ferran.adria@elbulli.com', '42381093238', DATETIME('now'), DATETIME('now'));
      INSERT INTO chefs
      (first_name, last_name, birthday, email, phone, created_at, updated_at)
      VALUES
      ('Abel', 'Rodriguez', '1970-03-24', 'abel@gmail.com', '52381093238', DATETIME('now'), DATETIME('now'));
        -- Añade aquí más registros
        SQL
        )
  end


  private
  #Method to access 'chef' DB
  def self.db
    @@db ||= SQLite3::Database.new("chefs.db")
  end

end