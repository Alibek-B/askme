class QuestionsController < ApplicationController
  before_action :load_question, only: %i[ show edit update destroy ]
  before_action :authorize_user, except: [:create]

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
   def create
    @question = Question.new(question_params)

    @question.user = current_user

    if @question.save
      redirect_to user_path(@question.user), notice: "Вопрос задан"
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    if @question.update(question_params)
      redirect_to user_path(@question.user), notice: 'Вопрос сохранен'
    else
      render :edit
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    #user = @question.user
    @question.destroy

    redirect_to user_path(@question.user), notice: "Вопрос удален"
  end

  private
  def authorize_user
    reject_user unless @question.user == current_user
  end

    # Use callbacks to share common setup or constraints between actions.
    def load_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:user_id, :text, :answer)
    end
end
