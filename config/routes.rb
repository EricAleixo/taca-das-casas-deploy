Rails.application.routes.draw do
  resources :turmas
  resources :alunos do
    member do
      get :responder_questoes
      post :salvar_respostas
    end
  end

  resources :questaos
  resources :casas do
    collection do
      get :atribuicao_pontual_especial # Página com a lista de casas
      post :adicionar_pontos # Atribuição dos pontos
    end
  end

  # Rota padrão
  root "casas#index"
end
