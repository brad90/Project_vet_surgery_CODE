require_relative('../db/sqlrunner.rb')
require_relative('./visit.rb')
require( 'pry-byebug' )


class Animal
  attr_reader :name, :dob, :type_of_animal, :id, :owner_name
  attr_accessor :owner_email,:owner_phone_number, :assigned_vet

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @dob = options['dob']
    @type_of_animal = options['type_of_animal']
    @owner_name = options ['owner_name']
    @owner_email = options['owner_email']
    @owner_phone_number = options['owner_phone_number']
    @assigned_vet = options['assigned_vet']
    @check_in = Time.new,
    @check_out = Time.new
  end


  #save - create new animal in vet
  def save()
    sql ="INSERT INTO animals
    (
      name,
      dob,
      type_of_animal,
      owner_name,
      owner_email,
      owner_phone_number,
      assigned_vet
    )VALUES(
      $1,
      $2,
      $3,
      $4,
      $5,
      $6,
      $7
      )RETURNING id"
    values = [@name, @dob, @type_of_animal, @owner_name, @owner_email,
              @owner_phone_number, @assigned_vet]
    results = SqlRunner.run(sql, values)
    @id = results[0]['id']
  end

  def update
    sql = "UPDATE animals SET (name, dob, type_of_animal, owner_name,
    owner_email, owner_phone_number, assigned_vet)
    = ($1, $2, $3, $4, $5, $6, $7) WHERE id = $8"
    values = [@name, @dob, @type_of_animal, @owner_name, @owner_email,
    @owner_phone_number, @assigned_vet, @id]
    SqlRunner.run(sql,values)
  end
  #
  def delete()
    sql = "DELETE FROM animals WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def visits()
    sql = "SELECT * FROM visits
            WHERE animal_id = $1"
    values=[@id]
    result = SqlRunner.run(sql, values)
    visits = result.map {|data| Visit.new(data)}
    return visits
  end

  def check_in
    sql = "SELECT * FROM visits
          WHERE animal_id = $1"
    values=[@id]
    result = SqlRunner.run(sql, values)
    visit = result.map { |data| Visit.new(data)}.first
    return visit.check_in
  end






  def self.count()
    sql = "SELECT COUNT(*) FROM animals"
    result = SqlRunner.run(sql)[0]['count']
    return result
  end

  def self.delete_all()
    sql="DELETE FROM animals"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM animals WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values).first
    animal = Animal.new(result)
    return animal
  end

  def self.map_items(animal_data)
    return animal_data.map{|data| Animal.new(data)}
  end

  def self.all()
    sql = "SELECT * FROM animals"
    result = SqlRunner.run(sql)
    animal_list = map_items(result)
    return animal_list
  end




  def check_in
    sql = " SELECT visits.check_in FROM visits WHERE check_out IS NULL"
    results = SqlRunner.run(sql)
    animal_check_out = results.map{|animal| Animal.new(animal)}
    return animal_check_out
  end






end
