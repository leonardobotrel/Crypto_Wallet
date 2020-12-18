namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Cleaning DB...") do
        %x(rails db:drop)
      end

      show_spinner("Creating DB...") do
        %x(rails db:create)
      end

      show_spinner("Migrating DB...") do
        %x(rails db:migrate)
      end

      %x{rails dev:add_mining_types}
      
      %x{rails dev:add_coins}
    else
      puts "You aren't in developmente environment."
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Creating coins...") do
      coins = [
          {
              description: "Bitcoin",
              acronym: "BTC",
              url_image: "https://img2.gratispng.com/20180330/wgw/kisspng-bitcoin-cryptocurrency-monero-initial-coin-offerin-bitcoin-5abdfe6b87dad3.2673609815224008755565.jpg",
              mining_type: MiningType.all.sample
          },
          {
              description: "Ethereum",
              acronym: "ETH",
              url_image: "https://img2.gratispng.com/20180516/vgq/kisspng-ethereum-cryptocurrency-blockchain-logo-eos-io-crypto-5afc9ab9e70b61.4199610615265041219464.jpg",
              mining_type: MiningType.all.sample
          },
          {
              description: "Dash",
              acronym: "DASH",
              url_image: "https://www.pinclipart.com/picdir/middle/556-5565319_dash-coin-png-email-contact-clipart.png",
              mining_type: MiningType.all.sample
          }
      ]
      
      coins.each do |coin|
          Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra dos tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Creating mining types...") do
      mining_types = [
        {
          description: "Proof of Work",
          acronym: "Pow"
        },
        {
          description: "Proof of Stake",
          acronym: "Pos"
        },
        {
          description: "Proof of Capacity",
          acronym: "PoC"
        }
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end
  

  private
  
  def show_spinner (msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})") # Stop animation
  end
end
