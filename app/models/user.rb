require 'uri'
require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  VALID_USERNAME = /\A\w+\z/

  attr_accessor :password

  has_many :questions, dependent: :destroy
  has_many :asked_questions, class_name: 'Question', foreign_key: :author_id, dependent: :nullify

  before_validation :downcase_username, :downcase_email
  before_save :encrypt_password

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username, length: { maximum: 40 }
  validates :username, format: { with: VALID_USERNAME }

  validates :password, on: :create, presence: true
  validates :password, confirmation: true

  validates :avatar_url, format: { with: URI::DEFAULT_PARSER.make_regexp, allow_blank: true }

  validates :profile_color, format: { with: /\A#\h{6}\z/ }

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end


  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    user = find_by(email: email)

    # Если пользователь не найден, возвращает nil
    return nil unless user.present?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(
        password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
      )
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end

  private

  def downcase_username
    username.downcase! if username.present?
  end

  def downcase_email
    email.downcase! if email.present?
  end

  def encrypt_password
    if password.present?
      # Создаем т.н. «соль» — случайная строка, усложняющая задачу хакерам по
      # взлому пароля, даже если у них окажется наша БД.
      #У каждого юзера своя «соль», это значит, что если подобрать перебором пароль
      # одного юзера, нельзя разгадать, по какому принципу
      # зашифрованы пароли остальных пользователей
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # Создаем хэш пароля — длинная уникальная строка, из которой невозможно
      # восстановить исходный пароль. Однако, если правильный пароль у нас есть,
      # мы легко можем получить такую же строку и сравнить её с той, что в базе.
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

      # Оба поля попадут в базу при сохранении (save).
    end
  end
end
