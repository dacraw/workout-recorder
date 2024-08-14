module GeminiAssistant
    def evaluate_exercise(exercise_id)
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        exercise = Exercise.find_by id: exercise_id

        if !exercise.present?
            throw "No exercise found"
        end

        exercise_name = exercise.name
        exercise_description = exercise.description

        bot.eval(<<-HEREDOC
            exercise name: #{exercise_name}
            exercise description: #{exercise_description}
        HEREDOC
        )
    end

    def evaluate_exercise_name_and_description(name, description)
        if !name || ! description
            puts "Missing name and/or description"
            return
        end

        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        bot.eval(
            <<-HEREDOC
                exercise name: #{name}
                exercise description: #{description}
            HEREDOC
        )
    end
end