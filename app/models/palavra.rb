class Palavra < ActiveRecord::Base
  validates :word, uniqueness: true
end
