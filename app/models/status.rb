class Status < ActiveRecord::Base
  validates :twitter_status_id, :uniqueness => true, :presence => true
  validates :body, :presence => true, :length => { maximum: 140 }
  validates :twitter_user_id, :presence => true

  def self.fetch_by_user_id!(twitter_user_id)
    old_ids = Status.where(twitter_user_id: twitter_user_id).pluck(:twitter_status_id)
    statuses = TwitterSession.get("statuses/user_timeline", {user_id: twitter_user_id})

    statuses.select! { |hash| !old_ids.include?(hash["id_str"]) }

    statuses.each do |status|
      Status.create!(
        twitter_status_id: status["id_str"],
        twitter_user_id: status["user"]["id_str"],
        body: status["text"]
      )
    end

  end

  def self.post(body)
    status = TwitterSession.post("statuses/update", {status: body})

    Status.create!(
      twitter_status_id: status["id_str"],
      twitter_user_id: status["user"]["id_str"],
      body: status["text"]
    )
  end






end
