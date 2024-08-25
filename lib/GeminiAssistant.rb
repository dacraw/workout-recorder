module GeminiAssistant
    def evaluate_workout(workout_id)
        begin
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
        rescue StandardError => e
            puts e
            "There was a safety issue with your workout information. As long as you are using safe language, try re-evaluating the workout since sometimes the chatbot misunderstands."
        end
    end

    def evaluate_exercise_name_and_description(name, description)
        if !name || ! description
            puts "Missing name and/or description"
            return
        end

        begin
            bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

            bot.eval(
                <<-HEREDOC
                    Provide a one sentence analysis and one sentence improvement for the following exercise:
                    
                    exercise name: #{name}
                    exercise description: #{description}
                HEREDOC
            )
        rescue StandardError => e
            puts e
            "There was a safety issue evaluating the exercise - please ensure you are using appropriate language and try editing then saving the exercise to re-generate an analysis."
        end
    end

    def suggest_exercise_based_on_type(type, existing_exercise_info)
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        begin
            bot.eval(<<-HEREDOC
                Suggest an exercise based on the following muscle groups: #{type}

                The suggested exercise should not be a duplicate of any of these exercises:
                #{existing_exercise_info}

                Please provide only the exercise name and sets/reps, separated by a hyphen. Please provide only one exercise.
            HEREDOC
            )
        rescue StandardError => e 
            puts "Error with suggest_exercise_based_on_type: #{e}"
            "There was a safety issue evaluating the exercise - please ensure you are using appropriate language and try editing then saving the exercise to re-generate an analysis."
        end
    end
end