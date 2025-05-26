require 'rails_helper'

RSpec.describe "home/index", type: :view do
  context "when user is not signed in" do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
    end

    it "displays the welcome heading" do
      expect(rendered).to have_css("h1.display-4", text: "Bem-vindo ao Family Budget")
    end

    it "displays the lead paragraph" do
      expect(rendered).to have_css("p.lead", text: "Gerencie seu orçamento familiar de forma simples e eficiente")
    end

    it "displays the feature boxes" do
      expect(rendered).to have_css(".feature-box", count: 3)
    end

    it "displays the registration CTA button" do
      expect(rendered).to have_link("Começar Agora", href: new_user_registration_path)
    end

    it "displays the login link" do
      expect(rendered).to have_link("Faça login", href: new_user_session_path)
    end
  end

  context "when user is signed in" do
    let(:user) { instance_double("User", email: "user@example.com") }

    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
      render
    end

    it "displays the dashboard button instead of registration button" do
      expect(rendered).not_to have_link("Começar Agora", href: new_user_registration_path)
      expect(rendered).to have_link("Ir para Dashboard")
    end

    it "does not display the login link" do
      expect(rendered).not_to have_link("Faça login", href: new_user_session_path)
    end
  end
end
