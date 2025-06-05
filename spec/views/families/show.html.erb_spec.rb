require 'rails_helper'

RSpec.describe 'families/show.html.erb', type: :view do
  let(:user) { create(:user) }
  let(:family) { create(:family, user: user, name: 'Família Silva', description: 'Uma família unida') }

  before do
    assign(:family, family)
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'displays the family name' do
    render
    expect(rendered).to match(/Família Silva/)
  end

  it 'displays the family description' do
    render
    expect(rendered).to match(/Uma família unida/)
  end

  it 'displays the creation date' do
    render
    expect(rendered).to match(/Criada em:/)
  end

  it 'displays edit link' do
    render
    expect(rendered).to have_link('Editar', href: edit_family_path)
  end

  it 'displays delete link' do
    render
    expect(rendered).to have_link('Excluir', href: family_path)
  end

  it 'displays family statistics' do
    render
    expect(rendered).to match(/Membros/)
    expect(rendered).to match(/Transações/)
  end

  it 'displays administrator information' do
    render
    expect(rendered).to match(/Administrador/)
    expect(rendered).to match(/#{user.email}/)
  end

  context 'when family has no description' do
    let(:family) { create(:family, user: user, name: 'Família Silva', description: nil) }

    it 'does not display description section' do
      render
      expect(rendered).not_to match(/Descrição:/)
    end
  end
end
