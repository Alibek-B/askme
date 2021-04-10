class Question < ApplicationRecord
  belongs_to :user

  validates :text, :user,  presence: true

  #Проверка длина вопроса
  validates_length_of :text,  :maximum => 255
end
