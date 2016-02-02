class QuestionsIndex < Chewy::Index
  # settings analysis: {
    # analyzer: {
      # email: {
        # tokenizer: 'keyword',
        # filter: ['lowercase']
      # }
    # }
  # }

  define_type Question.includes(:subdang, :hashtags, :badges, :options) do
    field :text, :type
    field :subdang, value: ->(question) { question.subdang.try(:name) }
    field :hashtags, value: ->(question) { question.hashtags.map(&:name) }
    # field :options, value: ->(question) { question.options.map(&:text) }
    field :views_count, type: 'integer' # custom data type
    field :created, type: 'date', include_in_all: false, value: -> { created_at }
  end
end
