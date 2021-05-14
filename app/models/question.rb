class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  #Проверка длина вопроса
  validates :text,  length: { maximum: 255 }
end
