class Question::MultipleChoice
  # constants
  OPTIONS_COUNT_IN = 2..4

  def validate_options(question)
    options_validator.validate(question)
  end

  def need_validate_option_correct?(question)
    (OPTIONS_COUNT_IN).include?(question.options.size)
  end

  private

  def options_validator
    @options_validator ||= ActiveModel::Validations::LengthValidator.new(
      attributes: :options, in: OPTIONS_COUNT_IN
    )
  end
end
