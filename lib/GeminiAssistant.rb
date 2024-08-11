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
end