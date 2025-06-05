require 'rails_helper'

RSpec.describe 'families/new.html.erb', type: :view do
  let(:family) { Family.new }

  before do
    assign(:family, family)
  end

  it 'renders the form' do
    render
    expect(rendered).to have_selector('form')
  end

  it 'displays the page title' do
    render
    expect(rendered).to match(/Criar Nova Família/)
  end

  it 'has name input field' do
    render
    expect(rendered).to have_field('family[name]')
  end

  it 'has description textarea' do
    render
    expect(rendered).to have_field('family[description]')
  end

  it 'has submit button' do
    render
    expect(rendered).to have_button('Criar Família')
  end

  it 'has cancel link' do
    render
    expect(rendered).to have_link('Cancelar', href: root_path)
  end

  it 'displays explanatory text' do
    render
    expect(rendered).to match(/Crie uma família para gerenciar as finanças em conjunto/)
  end

  context 'when family has errors' do
    before do
      family.errors.add(:name, 'não pode ficar em branco')
      assign(:family, family)
    end

    it 'displays error messages' do
      render
      expect(rendered).to match(/Erro ao criar família/)
      expect(rendered).to match(/não pode ficar em branco/)
    end
  end
end
