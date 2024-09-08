module GeminiAssistant
    def self.evaluate_workout(workout_id)
        begin
            bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

            workout = Workout.includes(:exercises).find_by(id: workout_id)
            exercises = workout.exercises

            return "Please add exercises to this workout before evaluating it." if exercises.size == 0

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

    def self.evaluate_exercise_name_and_description(name, description)
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

    def self.evaluate_exercise(exercise)
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        sets = exercise.exercise_sets
        exercise_set_string = ""

        if exercise.exercise_sets.size > 0
            exercise.exercise_sets.each do |set| 
                exercise_set_string += set.reps.to_s + " reps" if set.reps
                exercise_set_string += "," if set.reps && set.weight
                exercise_set_string += set.weight.to_s if set.weight
                exercise_set_string += set.weight_unit if set.weight
                exercise_set_string += "; "
            end
        end
        
        prompt = <<-HEREDOC
            Provide a one sentence analysis and one sentence improvement for the following exercise:    
            
            Exercise Name: #{exercise.name}
            Exercise Description (optional): #{exercise.description}
            Number of Reps AND OR Weight during exercise (optional): #{exercise_set_string}

            If you cannot provide an analysis with the given information, please respond with "I'm sorry, but I cannot provide a meaningful analysis with the exercise information provided." Please maintain an professional and enthusiastic tone. Please keep the response three sentences long.

        HEREDOC

        bot.eval(prompt)
    end

    def self.suggest_exercise_based_on_type(type, existing_exercise_info)
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

    def self.suggest_workout_based_on_type(type, existing_exercise_info = "")
        bot = NanoBot.new(cartridge: CARTRIDGE_CONFIG)

        begin
            bot.eval(<<-HEREDOC
                Provide a list of exercises that includes the following muscle groups: #{type}

                The list should not include any of these exercises:
                #{existing_exercise_info}

                Please provide each list item as the exercise name (in bold text) and its sets/reps, separated by a hyphen. Please provide at least one exercise per muscle group. 
            HEREDOC
            )
        rescue StandardError => e 
            puts "Error with suggest_workout_based_on_type: #{e}"
            "There was an issue suggesting the workout - please try evaluating again, or change the selected muscle groups."
        end
    end
end