class OptionsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless option_correct_valid?(record)
      record.errors.add(:base, :options_too_short)
      # record.errors[attribute] << (options[:message] || "is not an email")
    end
  end

  private

  def option_correct_valid?(record)
    record.options.map(&:correct).select { |item| item == true }.count == 1
  end
end
