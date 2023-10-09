namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando o db"){%x(rails db:drop)}
      
      show_spinner("Criando o db"){%x(rails db:create)}
      
      show_spinner("Migrando o db"){%x(rails db:migrate)}
      
      show_spinner("Populando o db"){%x(rails db:seed)}
      
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
      
      
    
    else
        puts 'Você não esta em ambiente de desenvolvimento'
    end
  end
  
  desc"Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas") do

coins = [
            {
                description: 'Bitcoin',
                acronym: 'BTC',
                url_image:'https://e7.pngegg.com/pngimages/27/1/png-clipart-bitcoin-logo-bitcoin-logo-monochrome-thumbnail.png',
                mining_type: MiningType.find_by(acronym).first
            },        
            {    
                description: 'Ethereum',
                acronym: 'ETH',
                url_image:'data:image/png;base64,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',
                mining_type: MiningType.find_by(acronym).first     
            },        
            {
                description: 'DASH',
                acronym: 'DASH',
                url_image:'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXepRfnxXtZIBz1kBNf5hkTcPj40sMQd7f4QRFsCo83c9f4fPyZ8maajthtgCTe04Ba6c&usqp=CAU',
                mining_type: MiningType.find_by(acronym).first
            }
       ]
       
      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end
    
    desc "Cadastro dos tipos de mineração"
    task add_mining_types: :environment do
      show_spinner("Cadastrando tipos de mineraçao...") do
      mining_types = [
      {
        description: "Proof of Work", acronym: "Pow"
      },
      
      {
         description: "Proof of Stake", acronym: "PoS"
      },
      
      {
         description: "Proof of Capacity", acronym: "PoC"
      },
  
      ]
        mining_types.each do |mining_type|
          MiningType.find_or_create_by!(mining_type)
      end
    end  
  end    
    def show_spinner(msg_start, msg_end = 'Concluído')
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
      spinner.auto_spin
      yield
      spinner.success("(#{msg_end})")
    end
end
