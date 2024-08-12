module GeminiAssistant
    def evaluate_workout(workout_id)
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        workout = Workout.find_by id: workout_id

        if !workout.present?
            throw "No workout found"
        end

        workout_name = workout.name
        workout_description = workout.description

        bot.eval(<<-HEREDOC
            workout name: #{workout_name}
            workout description: #{workout_description}
        HEREDOC
        )
    end

    def evaluate_workout_name_and_description(name, description)
        if !name || ! description
            puts "Missing name and/or description"
            return
        end

        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        bot.eval(
            <<-HEREDOC
                workout name: #{name}
                workout description: #{description}
            HEREDOC
        )
    end
end