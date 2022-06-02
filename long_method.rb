# This method isn't really long enough to warrant refactoring in the real world in my opinion,
# but we'll use it as a demonstration case.

class QuestionsController
  def create
    @survey = Survey.find(params[:survey_id])
    question_params = params.require(:question).permit(:title)
    @question = Question.new(question_params)
    @question.survey = @survey

    if @question.save
      redirect_to @survey
    else
      render :new
    end
  end
end
