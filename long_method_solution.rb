# Solutions
# • *Extract method* is the most common way to break apart long methods.
# • *Replace temp with query* if you have local variables in the method.

class QuestionController

  def create
    @survey = Survey.find(params[:survey_id])
    build_question
    if @question.save
      redirect_to @survey
    else
      render :new
    end
  end

  private

  # This is a so called 'command' method.
  # We extracted it out into it's own method.
  def build_question
    @question = Question.new(question_params)
    @question.survey = @survey
  end

  # This is a so called 'query' method.
  # We replaced the temporary variable question_params with a query method.
  def question_params
    params.require(:question).permit(:title)
  end

end
