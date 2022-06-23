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
require 'time'

class ShortenedUrl < ApplicationRecord
    validates :short_url, :user_id, presence: true, uniqueness: true 

    belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

    has_many :visitors,
        Proc.new { distinct },
        through: :visits,
        source: :visitor

    def self.random_code 
        new_code = SecureRandom.urlsafe_base64
        ShortenedUrl.random_code if ShortenedUrl.exists?(:short_url => new_code)
        return new_code
    end

    def self.create_short_url(user, long_url)
        ShortenedUrl.create!(:user_id => user.id, :long_url => long_url, :short_url => ShortenedUrl.random_code)
    end

    def num_clicks
        Visit
            .select('COUNT(*)')
            .where('url_id = self.id')
    end

    def num_uniques
        Visit
            .select('COUNT(DISTINCT user_id)')
    end

    def num_recent_uniques
        Visit
            .select('COUNT(DISTINCT user_id)')
            .where('created_at BETWEEN Time.now AND 10.minutes.ago')
    end
end
