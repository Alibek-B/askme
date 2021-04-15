class UsersController < ApplicationController
  def index
    @users = [
      User.new(
        id: 1, 
        name: 'Alibek',
        username: 'ibb',
      ),

      User.new(
        id: 2, 
        name: 'Al', 
        username: 'al',
      )
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Alibek',
      username: 'ibb',
    )

    @questions = [
      Question.new(text: 'Как дела?', created_at: Date.parse('14.04.2021')),
      Question.new(text: 'В чем смысл жизни?', created_at: Date.parse('14.04.2021')),
    ]

    @new_question = Question.new
  end
end
