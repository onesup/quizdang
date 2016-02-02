class Question::Ox
  # constants
  OPTIONS_COUNT = 2

  def validate_options(question)
    options_validator.validate(question)
  end

  def need_validate_option_correct?(question)
    question.options.size == OPTIONS_COUNT
  end

  private

  def options_validator
    @options_validator ||= ActiveModel::Validations::LengthValidator.new(
      attributes: :options, is: OPTIONS_COUNT
    )
  end
end
