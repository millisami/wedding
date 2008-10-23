# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def show_price(price)
	number_to_currency(CurrencyExchange.currency_exchange(price, "SEK", session[:exchange_currency]))
    end
end
