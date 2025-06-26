require 'rails_helper'

RSpec.describe 'shared/_navbar', type: :view do
  before do
    # Include ApplicationController helpers in view tests
    view.extend ApplicationController._helpers
  end
  context 'when user is not signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render partial: 'shared/navbar'
    end

    it 'displays login button' do
      expect(rendered).to have_link('Entrar', href: new_user_session_path)
    end

    it 'displays sign up button' do
      expect(rendered).to have_link('Cadastrar', href: new_user_registration_path)
    end

    it 'does not display dashboard link' do
      expect(rendered).not_to have_link('Dashboard')
    end

    it 'does not display finances dropdown' do
      expect(rendered).not_to have_content('Finanças')
      expect(rendered).not_to have_link('Todas as Transações')
      expect(rendered).not_to have_link('Nova Transação')
    end

    it 'does not display user profile dropdown' do
      expect(rendered).not_to have_content('Meu Perfil')
      expect(rendered).not_to have_content('Configurações')
      expect(rendered).not_to have_content('Sair')
    end
  end

  context 'when user is signed in' do
    let(:user) { create(:user, email: 'test@example.com') }

    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
    end

    context 'when user needs family setup' do
      before do
        allow(view).to receive(:user_needs_family_setup?).and_return(true)
        render partial: 'shared/navbar'
      end

      it 'displays create family link' do
        expect(rendered).to have_link('Criar Família', href: new_family_path)
      end

      it 'does not display dashboard link' do
        expect(rendered).not_to have_link('Dashboard')
      end

      it 'does not display finances dropdown' do
        expect(rendered).not_to have_content('Finanças')
      end

      it 'displays user profile dropdown' do
        expect(rendered).to have_content(user.profile.first_name)
      end

      it 'does not display login button' do
        expect(rendered).not_to have_link('Entrar')
      end

      it 'does not display sign up button' do
        expect(rendered).not_to have_link('Cadastrar')
      end
    end

    context 'when user has family' do
      before do
        allow(view).to receive(:user_needs_family_setup?).and_return(false)
        render partial: 'shared/navbar'
      end

      it 'displays dashboard link' do
        expect(rendered).to have_link('Dashboard')
      end

      it 'displays finances dropdown' do
        expect(rendered).to have_content('Finanças')
      end

      it 'displays finances dropdown items' do
        expect(rendered).to have_link('Todas as Transações')
        expect(rendered).to have_link('Nova Transação')
      end

      it 'displays user profile dropdown' do
        expect(rendered).to have_content(user.profile.first_name)
      end

      it 'displays user profile dropdown items' do
        expect(rendered).to have_link('Meu Perfil')
        expect(rendered).to have_link('Configurações')
        expect(rendered).to have_content('Sair')
      end

      it 'does not display login button' do
        expect(rendered).not_to have_link('Entrar')
      end

      it 'does not display sign up button' do
        expect(rendered).not_to have_link('Cadastrar')
      end
    end
  end
end
