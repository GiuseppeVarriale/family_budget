RSpec.configure do |config|
  # Configuração personalizada para saída de testes
  config.example_status_persistence_file_path = './spec/examples.txt'

  # Exibe a saída em cores
  config.color_mode = :on

  # Desativa a exibição dos testes mais lentos
  config.profile_examples = 0

  # Adiciona informações sobre o local dos arquivos no output
  config.add_formatter :progress

  # Configura para mostrar mensagens de falha com o caminho do arquivo
  config.backtrace_exclusion_patterns = [
    %r{/lib\d*/ruby/},
    %r{bin/},
    /gems/,
    %r{spec/spec_helper\.rb},
    %r{lib/rspec/(core|expectations|matchers|mocks)}
  ]

  # Define mensagens de falha mais informativas
  config.failure_color = :red
  config.tty = true
end
