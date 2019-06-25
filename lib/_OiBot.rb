require 'forecast_io'
require 'telegram/bot'


class OiBot 
  def self.telegram(for:)

    # Getting all the keys I need
    token = ENV.fetch('TELEGRAM_TOKEN')
    ForecastIO.api_key = ENV.fetch('DARKSKY_KEY')

    # pull weather data from API and turn Hashie to a hash
    @forecast = ForecastIO.forecast(35.1591, -85.2182)
    @forecast = @forecast.to_hash

    # make the telegram bot start listening for commands
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text:'Hello, #{message.from.first_name}, here is what I can do for you:
            /todayWeather
            /weekWeather')

        when '/todayWeather'
          #pull out only the data for today and send it
          current_summary = @forecast['currently']
          bot.api.send_message(chat_id: message.chat.id, text: "today is #{current_summary["temperature"]}F and #{(current_summary['summary']).downcase}.\nprobability of rain: #{((current_summary['precipProbability']) * 100)}%\n ")
        
        when '/weekWeather'  
          @forecast["daily"].each do |key, value|
            if key == "data"
              value.each do |n|
                date = Time.at(n['time'])
                bot.api.send_message(chat_id: message.chat.id, text: "#{date.month}/#{date.day}\nprobability of rain: #{((n['precipProbability']) * 100)}%\nHigh: #{n['temperatureMax']}F\tLow: #{n['temperatureMin']}F\n#{n['summary']}")
              end
            end
          end

        when

        end

      end

    end

  end

end


