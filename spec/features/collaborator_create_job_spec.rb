require 'rails_helper'

feature 'collaborator create job' do
    scenario 'it is necessary to authenticate' do
        visit new_employees_backoffice_job_path()
        expect(current_path()).to eq(new_employee_session_path())
        expect(page).not_to have_content('Nova vaga de trabalho')
    end

    scenario 'attributes cannot be blank' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)
        
        login_as(employee, scope: :employee)

        visit root_path()
        find('nav') do
            expect(page).to have_link('Vagas')
            click_on('Vagas')
        end

        expect(current_path()).to eq(employees_backoffice_jobs_path())
        expect(page).to have_link('Cadastrar vaga')
        click_on('Cadastrar vaga')
        expect(current_path()).to eq(new_employees_backoffice_job_path())
        expect(page).to have_content('Nova vaga de trabalho')

        find('form') do
            fill_in('Título', with: '')
            fill_in('Descrição', with: '')
            fill_in('Menor salário', with: '')
            fill_in('Maior salário', with: '')
            fill_in('Quantidade', with: '')
            click_on 'Cadastrar'
        end

        find('div .notification') do
            expect(page).to have_content('Título não pode ficar em branco')
            expect(page).to have_content('Descrição não pode ficar em branco')
            expect(page).to have_content('Menor salário não pode ficar em branco')
            expect(page).to have_content('Maior salário não pode ficar em branco')
            expect(page).to have_content('Quantidade não pode ficar em branco')
        end
    end

    scenario 'back to index' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)
        
        login_as(employee, scope: :employee)

        visit new_employees_backoffice_job_path()
        expect(page).to have_content('Nova vaga de trabalho')
        expect(page).to have_link('Voltar')
        click_link 'Voltar'
        expect(current_path).to eq(employees_backoffice_jobs_path)
    end

    scenario 'Success' do
        company = Company.create!(email_suffix: '@rco.com.br')
        employee = Employee.create!(email: 'romario@rco.com.br',
                                    password: '123456',
                                    company: company)
        Requirement.create!(title: 'Angular', description: 'framework front-end js')
        Requirement.create!(title: 'NodeJs', description: 'é um runtime js')
        Requirement.create!(title: 'React', description: 'lib front-end js')
        Requirement.create!(title: 'Ruby on Rails', description: 'framework fullstack web')
        
        login_as(employee, scope: :employee)

        visit new_employees_backoffice_job_path()
        expect(page).to have_content('Nova vaga de trabalho')

        find('form') do
            fill_in('Título', with: 'Desenvolvedor Rails')
            fill_in('Descrição', with: 'Vaga para atuar como desenvolvedor ruby on rails na empresa x')
            fill_in('Menor salário', with: 2000)
            fill_in('Maior salário', with: 3200)
            fill_in('Quantidade', with: 2)
            select('Junior', from: 'Nível')
            check('Ruby on Rails')
            check('Angular')
            uncheck('NodeJs')
            uncheck('React')
            click_on 'Cadastrar'
        end

        expect(current_path()).to eq(employees_backoffice_jobs_path())
        expect(page).to have_content('Vaga de emprego cadastrada com sucesso')
    end
end