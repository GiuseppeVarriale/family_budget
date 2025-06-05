require 'rails_helper'

RSpec.describe 'profiles/edit.html.erb', type: :view do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, first_name: 'João', last_name: 'Silva', user: user) }

  before do
    assign(:profile, profile)
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'renders the edit profile form' do
    render

    expect(rendered).to have_selector("form[action='#{profile_path}'][method='post']")
    expect(rendered).to have_field('profile_first_name', with: profile.first_name)
    expect(rendered).to have_field('profile_last_name', with: profile.last_name)
    expect(rendered).to have_field('profile_avatar')
  end

  it 'displays the form labels' do
    render

    expect(rendered).to have_content('Nome')
    expect(rendered).to have_content('Sobrenome')
    expect(rendered).to have_content('Foto de Perfil')
  end

  it 'includes the submit button' do
    render

    expect(rendered).to have_button('Atualizar Perfil')
  end

  it 'includes CSRF token' do
    render

    expect(rendered).to have_selector("input[name='authenticity_token']", visible: false)
  end

  it 'uses the correct form method override' do
    render

    expect(rendered).to have_selector("input[name='_method'][value='patch']", visible: false)
  end

  context 'when profile has existing data' do
    before do
      profile.update!(first_name: 'João', last_name: 'Silva')
      assign(:profile, profile)
    end

    it 'pre-fills the form with existing data' do
      render

      expect(rendered).to have_field('profile_first_name', with: 'João')
      expect(rendered).to have_field('profile_last_name', with: 'Silva')
    end
  end

  context 'when there are validation errors' do
    before do
      profile.errors.add(:first_name, 'não pode ficar em branco')
      profile.errors.add(:last_name, 'não pode ficar em branco')
      assign(:profile, profile)
    end

    it 'displays error messages' do
      render

      expect(rendered).to include('não pode ficar em branco')
    end
  end

  describe 'profiles/edit.html.erb' do
    let(:user) { create(:user) }
    let(:profile) { user.profile }
    before do
      render
    end

    it 'includes the submit button' do
      expect(rendered).to have_button('Atualizar Perfil')
    end

    it 'includes CSRF token' do
      expect(rendered).to have_selector("input[name='authenticity_token']", visible: false)
    end
  end
end
