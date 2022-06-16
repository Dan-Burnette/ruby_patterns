# EXAMPLE LIFTED FROM THE BOOK RUBY SCIENCE:


# This line of code was deemed hard enough to understand that adding a comment was necessary:

class Survey

  # "Text for each answer in order as a comma-separated string"
  def summary
    answers.order(:created_at).pluck(:text).join(', ')
  end

end

class Survey

  # This could be improved by adding an explaining variable to make the comment uncessary:
  def summary
    text_from_ordered_answers = answers.order(:created_at).pluck(:text)
    text_from_ordered_answers.join(', ')
  end

end


class Survey

  # You could follow up by using *replace temporary variable with query*
  def summary
    text_from_ordered_answers.join(', ')
  end

  private

  def text_from_ordered_answers
    answers.order(:created_at).pluck(:text)
  end

end

# These are very simple ideas that go a LOOONG way towards code readability.
