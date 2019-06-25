require 'forecast_io'
require 'telegram/bot'


class OiBot 
  def self.telegram(for:)

    # Getting all the keys I need
    token = ENV.fetch('TELEGRAM_TOKEN')
    ForecastIO.api_key = ENV.fetch('DARKSKY_KEY')

    # make the telegram bot start listening for commands
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/weather'
          # pull weather data from API and turn Hashie to a hash
          forecast = ForecastIO.forecast(35.1591, -85.2182)
          forecast = forecast.to_hash
          #pull out only the data for today and send it
          current_summary = forecast['currently']
          bot.api.send_message(chat_id: message.chat.id, text: "today is #{current_summary["temperature"]}F and #{(current_summary['summary']).downcase}.\nprobability of rain: #{((current_summary['precipProbability']) * 100)}%\n ")
        end

      end

    end

  end

end


