# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :view) do
    # Stub current_page? helper method that's used in navbar
    allow(view).to receive(:current_page?).and_return(false)
    allow(view).to receive(:current_page?).with(root_path).and_return(true)
  end
end
