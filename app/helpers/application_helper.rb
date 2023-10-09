module ApplicationHelper

    def locale
        I18n.locale == :en ? "Estados Unidos" : "Portugues do Brasil"
    end
    
    def ambiente_rails
        
        if Rails.env.development?
            'Development'
        elsif Rails.env.production?
            'Produçao'
        else        
            'Teste'
        end
    end        
        
end
