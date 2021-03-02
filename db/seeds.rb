puts '>>> Criando empresas ...'
company = Company.create!(email_suffix: '@treinadev.com.br', name: 'TreinaDev')
other_company = Company.create!(email_suffix: '@alura.com.br', name: 'Alura')
puts '>>> Criando funcionários ...'
employee = Employee.create!(email: 'romario@treinadev.com.br', password: '123456', company: company, name: 'Romário Costa Silva')
other_employee = Employee.create!(email: 'rauena@alura.com.br', password: '123456', company: other_company, name: 'Rauena Sousa Lima')
puts '>>> Criando administradores ...'
CompanyAdmin.create!(employee: employee, company: company)
CompanyAdmin.create!(employee: other_employee, company: other_company)
puts '>>> Criando candidatos ...'
candidate = Candidate.create!(email: 'maria@gmail.com', password: '123456')
other_candidate = Candidate.create!(email: 'raimundo@gmail.com', password: '123456')
puts '>>> Criando requisitos ...'
Requirement.create!(title: 'Angular', description: 'Framework criado pelo google')
Requirement.create!(title: 'C', description: 'Linguagem de programação c')
Requirement.create!(title: 'Java', description: 'Linguagem de programação java')
Requirement.create!(title: 'JavaScript', description: 'Linguagem de programação javascript')
Requirement.create!(title: 'Ruby', description: 'Linguagem de programação java')
Requirement.create!(title: 'PHP', description: 'Linguagem de programação php')
Requirement.create!(title: 'Python', description: 'Linguagem de programação python')
Requirement.create!(title: 'Ruby on Rails', description: 'framework fullstack para web')
Requirement.create!(title: 'Django', description: 'framework fullstack para web')
Requirement.create!(title: 'Laravel', description: 'framework fullstack para web')
Requirement.create!(title: 'NodeJs', description: 'runtime js')
Requirement.create!(title: 'ReactJs', description: 'lib js para frontend')
Requirement.create!(title: 'VueJs', description: 'lib js para frontend')
puts '>>> Criando vagas de emprego ...'
Job.create!(title: 'Programador Ruby',
    description: 'Vaga para programador ruby',
    quantity: 2,
    level: 10,
    lowest_salary: 1800,
    highest_salary: 3000,
    deadline_for_registration: DateTime.new(2021, 10, 20, 23, 59),
    employee_id: employee.id,
    company_id: company.id
)
JobRequirement.create!(job_id: 1, requirement_id: 5)

Job.create!(title: 'Programador Angular',
    description: 'Vaga para programador angular',
    quantity: 5,
    level: 20,
    lowest_salary: 3000,
    highest_salary: 4000,
    deadline_for_registration: DateTime.new(2021, 10, 20, 23, 59),
    employee_id: employee.id,
    company_id: company.id
)

JobRequirement.create!(job_id: 2, requirement_id: 1)
JobRequirement.create!(job_id: 2, requirement_id: 4)

Job.create!(title: 'Programador Ruby on rails',
    description: 'Vaga para programador ruby on rails',
    quantity: 1,
    level: 30,
    lowest_salary: 5000,
    highest_salary: 8000,
    deadline_for_registration: DateTime.new(2021, 10, 20, 23, 59),
    employee_id: employee.id,
    company_id: company.id
)

JobRequirement.create!(job_id: 3, requirement_id: 5)
JobRequirement.create!(job_id: 3, requirement_id: 8)

Job.create!(title: 'Desenvolvedor Ruby on rails',
    description: 'Vaga para desenvolvedor ruby on rails',
    quantity: 3,
    level: 20,
    lowest_salary: 4000,
    highest_salary: 6000,
    deadline_for_registration: DateTime.new(2021, 10, 20, 23, 59),
    employee_id: other_employee.id,
    company_id: other_company.id
)
JobRequirement.create!(job_id: 4, requirement_id: 5)
JobRequirement.create!(job_id: 4, requirement_id: 8)

Job.create!(title: 'Desenvolvedor NodeJs',
    description: 'Vaga para desenvolvedor nodejs',
    quantity: 5,
    level: 10,
    lowest_salary: 2000,
    highest_salary: 3500,
    deadline_for_registration: DateTime.new(2021, 10, 20, 23, 59),
    employee_id: other_employee.id,
    company_id: other_company.id
)

JobRequirement.create!(job_id: 5, requirement_id: 4)
JobRequirement.create!(job_id: 5, requirement_id: 11)

puts '>>> Criando candidaturas ...'
Application.create(candidate_id: 1, job_id: 1)
Application.create(candidate_id: 1, job_id: 2)
Application.create(candidate_id: 1, job_id: 5)
Application.create(candidate_id: 1, job_id: 4)
Application.create(candidate_id: 1, job_id: 5)
Application.create(candidate_id: 2, job_id: 1)
Application.create(candidate_id: 2, job_id: 2)
Application.create(candidate_id: 2, job_id: 3)
puts '>>> Finalizado <<<'