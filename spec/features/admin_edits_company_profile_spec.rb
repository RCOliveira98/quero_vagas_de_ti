require 'rails_helper'

feature 'admin edits company profile' do
    
  scenario 'success' do
    company = Company.create!(email_suffix: '@americanas.com.br')
    employee = Employee.create!(email: 'rco@americanas.com.br', password: '123456', company_id: 1)
    CompanyAdmin.create_or_find_admin(employee)

    login_as(employee, scope: :employee)

    visit employees_backoffice_root_path
    click_on 'perfil da empresa'
    click_on 'Editar'

    within('.container .columns form') do
      fill_in 'Nome', with: 'Americanas'
      fill_in 'Cnpj', with: '33014556000196'
      fill_in 'Site', with: 'www.americanas.com.br'
      fill_in 'País', with: 'Brasil'
      fill_in 'Estado', with: 'SP'
      fill_in 'Cidade', with: 'São Paulo'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Logradouro', with: 'Rua presidente x'
      fill_in 'Cep', with: '01010000'
      click_on 'Atualizar'
    end

    expect(current_path).to eq profile_employees_backoffice_company_path(id: 1)
    expect(page).to have_content('Perfil atualizado!')

  end

  scenario 'blank attributes' do
    company = Company.create!(email_suffix: '@americanas.com.br')
    employee = Employee.create!(email: 'rco@americanas.com.br', password: '123456', company_id: 1)
    CompanyAdmin.create_or_find_admin(employee)

    login_as(employee, scope: :employee)

    visit employees_backoffice_root_path
    click_on 'perfil da empresa'
    click_on 'Editar'

    within('.container .columns form') do
      fill_in 'Nome', with: ''
      fill_in 'Cnpj', with: ''
      fill_in 'Site', with: 'www.americanas.com.br'
      fill_in 'País', with: 'Brasil'
      fill_in 'Estado', with: 'SP'
      fill_in 'Cidade', with: 'São Paulo'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Logradouro', with: 'Rua presidente x'
      fill_in 'Cep', with: '01010000'
      click_on 'Atualizar'
    end

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Cnpj não pode ficar em branco')  
  end

  scenario 'upload de imagens' do
    company = Company.create!(email_suffix: '@americanas.com.br')
    employee = Employee.create!(email: 'rco@americanas.com.br', password: '123456', company_id: 1)
    CompanyAdmin.create_or_find_admin(employee)

    login_as(employee, scope: :employee)

    visit employees_backoffice_root_path
    click_on 'perfil da empresa'
    click_on 'Editar'

    within('.container .columns form') do
      fill_in 'Nome', with: 'Americanas'
      fill_in 'Cnpj', with: '33014556000196'
      attach_file 'Avatar', Rails.root.join('spec', 'support', 'logotipo.png')
      click_on 'Atualizar'
    end

    expect(current_path).to eq profile_employees_backoffice_company_path(id: 1)
    expect(page).to have_content('Perfil atualizado!')
    expect(page).to have_css('img[src*="logotipo.png"]')
  end
end