require('sinatra')
require('sinatra/contrib/all')
require_relative('../models/animal')
require_relative('../models/staff')
also_reload('./models/*')
require('pry')



#Animal CRUD

#Show me all the animals
get'/vet-surgery/animals'do
  @animals = Animal.all
erb(:index)
end

#Animal Create new animal
get '/vet-surgery/animals/new' do
  @staff = Staff.all()
  erb(:new)
end

#Save new animal
post '/vet-surgery/animals' do
  @animals = Animal.new(params)
  @animals.save()
  redirect to '/vet-surgery'
end

#Animal Update info
get '/vet-surgery/animals/:id/edit' do
  @staff = Staff.all
  @animal = Animal.find(params['id'])
  erb(:edit)
end

#Animal save updates
post '/vet-surgery/animals/:id' do
  animal = Animal.new(params)
  animal.update
  redirect to "/vet-surgery/#{params['id']}"
end

#Animal show one animal
get '/vet-surgery/animals/:id' do
  @animal = Animal.find(params[:id])
erb(:show)
end