namespace :app do
  namespace :questions do
    # run this on a cron every 10 minutes
    desc "increase view counts on questions"
    task increment_views: :environment do
      RedisClient.redis.smembers('question:tracking').each do |question_id|
        # puts '------'
        # puts question_id
        # IncreaseViews.new(question_id).delay(queue: 'views').update

        current_uniques_count = RedisClient.redis.scard("question:#{question_id}:uniques")
        current_tracked_count = RedisClient.redis.get("question:#{question_id}:tracked_uniques") || 0
        changed_count = current_uniques_count.to_i - current_tracked_count.to_i

        if changed_count > 0
          question = Question.find(question_id)
          question.increment!(:views_count, changed_count)

          RedisClient.redis.set("question:#{question_id}:tracked_uniques", current_uniques_count)
        end
      end
    end

    # run this nightly
    desc "clear tracked fingerprints for questions"
    task clear_tracked_questions: :environment do
      RedisClient.redis.smembers('question:tracking').each do |question_id|
        RedisClient.redis.del("question:#{question_id}:uniques")
        RedisClient.redis.del("question:#{question_id}:tracked_uniques")
      end

      RedisClient.redis.del('question:tracking')
    end
  end
end
