class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :question_id
  belongs_to :user
  belongs_to :question
  has_many :comments
  has_many :links
  has_many :files

  def files
    object.files.map { |file| rails_blob_url(file, host: :localhost) }
  end
end
