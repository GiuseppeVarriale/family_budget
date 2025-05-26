# frozen_string_literal: true

# Formatador personalizado que omite a seção de exemplos mais lentos
class CustomProgressFormatter < RSpec::Core::Formatters::ProgressFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_pending, :example_failed, :start_dump, :dump_pending, :dump_failures, :dump_summary, :seed

  def dump_profile(*)
    # Deliberadamente vazio para evitar a exibição do relatório de perfil
  end
end
