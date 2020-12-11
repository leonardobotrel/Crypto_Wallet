module ApplicationHelper
    def data_br(data_us)
        data_us.strftime("%d/%m/%Y")
    end

    def name_aplication
        "Crypto Wallet App"
    end
end
