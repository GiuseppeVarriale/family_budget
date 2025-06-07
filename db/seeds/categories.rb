# Create default categories for the application
puts 'Creating default categories...'

# Income categories
income_categories = [
  {
    name: 'Salário',
    description: 'Receita mensal proveniente de trabalho fixo.'
  },
  {
    name: 'Renda Extra',
    description: 'Valores recebidos além do salário principal, como freelances, trabalhos extras ou vendas eventuais.'
  },
  {
    name: 'Outros',
    description: 'Demais fontes de receita não categorizadas, como presentes em dinheiro, prêmios ou reembolsos.'
  }
]

expense_categories = [
  {
    name: 'Contas Obrigatórias',
    description: 'Gastos fixos essenciais como aluguel, financiamentos, seguros, condomínio e serviços básicos.'
  },
  {
    name: 'Imprevisto',
    description: 'Despesas não planejadas como reparos urgentes, consultas médicas ou situações emergenciais.'
  },
  {
    name: 'Diversão ou Supérfluos',
    description: 'Gastos com entretenimento, hobbies, compras por impulso e itens não essenciais.'
  },
  {
    name: 'Investimento',
    description: 'Valores destinados a aplicações financeiras, ações, fundos ou outros instrumentos de investimento.'
  },
  {
    name: 'Reserva de Emergência',
    description: 'Quantia poupada especificamente para formar ou complementar a reserva de emergência familiar.'
  }
]

income_categories.each do |category_data|
  category = Category.find_or_initialize_by(
    name: category_data[:name],
    category_type: :income
  )

  if category.new_record?
    category.description = category_data[:description]
    category.save!
    puts "  ✓ Created income category: #{category.name}"
  else
    puts "  → Income category already exists: #{category.name}"
  end
end

expense_categories.each do |category_data|
  category = Category.find_or_initialize_by(
    name: category_data[:name],
    category_type: :expense
  )

  if category.new_record?
    category.description = category_data[:description]
    category.save!
    puts "  ✓ Created expense category: #{category.name}"
  else
    puts "  → Expense category already exists: #{category.name}"
  end
end

puts 'Categories seed completed!'
puts "Total categories: #{Category.count} (#{Category.income.count} income, #{Category.expense.count} expense)"
