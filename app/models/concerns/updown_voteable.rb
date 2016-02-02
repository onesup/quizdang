# stackoverflow vote rule
# Thanks for the feedback! Once you earn a total of 15 reputation, your votes will change the publicly displayed post score.
module UpdownVoteable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    # FIXME: OPTIMIZE TODO https://github.com/twitter/activerecord-reputation-system/issues/62
    def desc_by_votes
      reorder('votes desc').find_with_reputation(:votes, :all)
    end
  end

  # OPTIMIZE: find_with_reputation || eager_load || reputation_for
  def votes
    self[:votes] || votes_reputation.try(:value) || reputation_for(:votes)
  end

  def voted_by?(user)
    upvoted_by?(user) || downvoted_by?(user)
  end

  def upvoted_by?(user)
    return false unless user
    has_evaluation?(:upvotes, user)
    # evaluations.where(reputation_name: 'upvotes').where(source: user).exists?
  end

  def downvoted_by?(user)
    return false unless user
    has_evaluation?(:downvotes, user)
    # evaluations.where(reputation_name: 'downvotes').where(source: user).exists?
  end

  private

  # OPTIMIZE: Eager Loading the Reputation Values for an Array
  # https://github.com/twitter/activerecord-reputation-system/issues/27
  # has_one :votes_reputation, -> { where(reputation_name: 'votes') }, class_name: 'ReputationSystem::Reputation', as: :target
  def votes_reputation
    reputations.find { |r| r.reputation_name == 'votes' }
  end
end
