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
            Provide a one sentence analysis and one sentence improvement for the following exercise:

            exercise name: #{exercise_name}
            exercise description: #{exercise_description}
        HEREDOC
        )
    end

    def evaluate_workout(workout_id)
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        workout = Workout.includes(:exercises).find_by(id: workout_id)
        exercises = workout.exercises

        exercise_text = exercises.map {|exercise| "exercise name: #{exercise.name}, exercise description: #{exercise.description}"}.join(";")

        heredoc_text = <<-HEREDOC
        Provide a one paragraph analysis of the following workout, which contains these exercises:
            #{exercise_text}

        HEREDOC

        return "Cannot analyze this workout as it does not exist" if workout.blank?

        bot.eval heredoc_text
            
    end

    def evaluate_exercise_name_and_description(name, description)
        if !name || ! description
            puts "Missing name and/or description"
            return
        end

        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        bot.eval(
            <<-HEREDOC
                Provide a one sentence analysis and one sentence improvement for the following exercise:
                
                exercise name: #{name}
                exercise description: #{description}
            HEREDOC
        )
    end

    def suggest_exercise(existing_exercise_info)
        # pass in the information from existing exercises, e.g. name: ...; description: ...;
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        bot.eval(<<-HEREDOC
            The current workout contains the following exercises:
            #{existing_exercise_info}


            Prompt: Suggest an exercise that falls into the same muscle categories as the example exercises, but isn't a duplicate of an existing exercise. The suggestion should have the following format:

            <<NAME OF EXERCISE>> (the name should be in bold font)
            <<ONE SENTENCE DESCRIPTION OF THE EXERCISE>>
        HEREDOC
        )
    end
end