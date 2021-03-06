# frozen_string_literal: true

class Article < ApplicationRecord
  has_many :url_contents, dependent: :destroy
  scope :user, ->(user) { where(user_id: user) }
  enum active: { active: 0, disable: 1 }

  class << self
    def create_with_url_content(article_params)
      article = Article.new(article_params)
      Article.transaction do
        article.save!
        UrlContent.create(article)
      end
    end

    def update_with_url_content(article_params, article)
      Article.transaction do
        article.update!(article_params)
        # urlが変わった時にはurl_contentも更新する
        break unless article.saved_change_to_url?

        UrlContent.update(article)
      end
    end
  end

  def delete
    disable!
  end
end
