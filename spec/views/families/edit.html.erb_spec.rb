require 'rails_helper'

RSpec.describe 'families/edit.html.erb', type: :view do
  let(:user) { create(:user) }
  let(:family) { create(:family, user: user, name: 'Família Silva', description: 'Uma família unida') }

  before do
    assign(:family, family)
  end

  it 'renders the form' do
    render
    expect(rendered).to have_selector('form')
  end

  it 'displays the page title' do
    render
    expect(rendered).to match(/Editar Família/)
  end

  it 'has name input field with current value' do
    render
    expect(rendered).to have_field('family[name]', with: 'Família Silva')
  end

  it 'has description textarea with current value' do
    render
    expect(rendered).to have_field('family[description]', with: 'Uma família unida')
  end

  it 'has submit button' do
    render
    expect(rendered).to have_button('Salvar Alterações')
  end

  it 'has cancel link' do
    render
    expect(rendered).to have_link('Cancelar', href: family_path)
  end

  context 'when family has errors' do
    before do
      family.errors.add(:name, 'é muito curto')
      assign(:family, family)
    end

    it 'displays error messages' do
      render
      expect(rendered).to match(/Erro ao atualizar família/)
      expect(rendered).to match(/é muito curto/)
    end
  end
end
