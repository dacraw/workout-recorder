

module GeminiAssistant
    def hello
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        puts bot.eval('Hello')
    end
end