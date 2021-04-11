class Question < ApplicationRecord
  belongs_to :user

  #Проверка длина вопроса
  validates :text,  length: { maximum: 255 }
end
