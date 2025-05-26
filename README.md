# Family Budget

[![CI](https://github.com/user/family_budget/actions/workflows/ci.yml/badge.svg)](https://github.com/user/family_budget/actions/workflows/ci.yml)

Aplicação para gerenciamento de orçamento familiar desenvolvida com Ruby on Rails.

## Requisitos

- Ruby 3.2.0+
- Rails 7.2.2+
- PostgreSQL 14+

## Configuração

1. Clone o repositório
2. Instale as dependências:
   ```bash
   bundle install
   ```
3. Configure o banco de dados:
   ```bash
   cp config/database.yml.example config/database.yml
   rails db:setup
   ```
4. Inicie o servidor:
   ```bash
   rails server
   ```

## Testes

Este projeto utiliza RSpec para testes. Para executar os testes:

```bash
bundle exec rspec
```

Para executar os testes com cobertura:

```bash
COVERAGE=true bundle exec rspec
```

O relatório de cobertura será gerado no diretório `coverage/`.

## CI/CD

Este projeto utiliza GitHub Actions para integração contínua. O pipeline inclui:

- Verificação de segurança com Brakeman
- Análise de estilo com RuboCop
- Execução de testes RSpec
- Verificação de vulnerabilidades em dependências

Consulte o arquivo [.github/workflows/ci.yml](.github/workflows/ci.yml) para mais detalhes.

## Documentação

Para mais informações sobre o projeto, consulte:

- [Cobertura de Testes](docs/test_coverage.md)
