get '/all-the-entries' do
  @entries = Entry.all
  erb :'entries/index'
end
