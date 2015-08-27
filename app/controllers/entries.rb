get '/all-the-entries' do
  @entries = Entry.all
  erb :'entries/index'
end

get '/new-entry-form' do
  erb :'entries/new'
end

post '/create-new-post' do
  entry = Entry.new(params[:entry])
  redirect entry.save ? '/all-the-entries' : '/create-new-post'
end

get '/show-one-entry/:id' do
  @entry = Entry.find(params[:id])
  erb :'entries/show'
end
