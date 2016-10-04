Rails.application.routes.draw do
  put '/correct' => 'corrections#correct'

  resources :corrections, only: [:index]
end
