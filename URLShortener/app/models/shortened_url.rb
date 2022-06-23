# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
require 'SecureRandom'

class ShortenedUrl < ApplicationRecord
    validates :short_url, :user_id, presence: true, uniqueness: true 

    belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

    has_many :visitors,
    through: :visits,
    source: :user

    def self.random_code 
        new_code = SecureRandom.urlsafe_base64
        ShortenedUrl.random_code if ShortenedUrl.exists?(:short_url => new_code)
        return new_code
    end

    def self.create_short_url(user, long_url)
        ShortenedUrl.create!(:user_id => user.id, :long_url => long_url, :short_url => ShortenedUrl.random_code)
    end
end
