class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validate :validate_campaigns_list

  def self.filter_by_campaign_name(campaign_names)
    if campaign_names.present?
      conditions = campaign_names.map do |value|
        "JSON_SEARCH(JSON_EXTRACT(campaigns_list, '$[*].campaign_name'), 'all', ?) IS NOT NULL"
      end.join(" OR ")

      where([conditions, *campaign_names])
    end
  end

  private

  def validate_campaigns_list
    unless campaigns_list.is_a?(Array) && campaigns_list.all?{|campaign| campaign.key?("campaign_name") && campaign.key?("campaign_id") }
      errors.add(:campaigns_list, "is provided wrong data")
    end
  end
end
