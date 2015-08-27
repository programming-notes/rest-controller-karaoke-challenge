get '/all-the-entries' do
  @entries = Entry.order(:created_at)
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

get '/edit-one-entry-form/:id' do
  @entry = Entry.find(params[:id])
  erb :'entries/edit'
end

post '/edit-one-entry-form/update-entry/:id' do
  entry = Entry.find(params[:id])
  entry.update_attributes(params[:entry])
  redirect "/show-one-entry/#{entry.id}"
end

get '/delete-entry/:id' do
  entry = Entry.find(params[:id])
  entry.destroy
  redirect '/all-the-entries'
end
