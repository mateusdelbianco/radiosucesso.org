Radiosucesso::Application.routes.draw do
  root :to => 'welcome#index'
  get '/next_id' => 'welcome#next_id'
end
