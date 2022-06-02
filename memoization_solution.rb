class CreateUserAnalysis # Say, for populating a dashboard or something like that.

  def initialize(user)
    @user = user
  end

  def call
    behavioral_analysis = analyze_user_behavior(user_usage_statistics)
    sentiment_analysis = analyze_user_sentiment(user_usage_statistics)

    {
      statistics: user_usage_statistics,
      behavioral_analysis: behavioral_analysis,
      sentiment_analysis: sentiment_analysis
    }
  end

  private

  def user_usage_statistics
    @user_usage_statistics ||= @user.calculate_usage_statistics
  end

  # Say @user.calculate_usage_statistics is a method that's expensive computationally (i.e. many database queries, etc).
  # By memoizing it like this:
  #
  # - The first call to user_usage_statistics will run @user.calculate_usage and set it to the
  # instance variable @user_usage_statistics
  #
  # - Subsequent calls to user_usage_statistics will return that cached AKA 'memoized' value  instead
  # of re-running @user.calculate_usage
  #
  # It allows you to essentially make a 'query method' that will do the expensive query once, and
  # then returns the result going forward. So it's a performance optimization to avoid re-doing
  # expensive stuff unnecessarily.

end
