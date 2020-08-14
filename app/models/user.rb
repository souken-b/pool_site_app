class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :line_link_nonce, dependent: :destroy
  def admin?
    return true if self.id == 1

    false
  end

  def self.save_line_user_id(nonce, line_user_id)
    link_user = LineLinkNonce.find_by(nonce: nonce).user
    link_user.line_user_id = line_user_id
    begin
      link_user.save!
      return true
    rescue ActiveRecord::RecordInvalid => e
      return false
    end
  end
end
