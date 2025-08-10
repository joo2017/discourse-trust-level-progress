# frozen_string_literal: true

class TrustLevelProgressCalculator
  def initialize(user)
    @user = user
    @user_stat = user.user_stat
  end

  def progress
    current_tl = @user.trust_level
    return { complete: true, message: I18n.t("trust_level_progress.highest_level") } if current_tl >= 4

    next_tl = current_tl + 1
    
    all_requirements = calculate_requirements_for(next_tl)
    met_requirements, unmet_requirements = all_requirements.partition { |r| r[:met] }

    {
      current_level: current_tl,
      next_level: next_tl,
      met_requirements: met_requirements,
      unmet_requirements: unmet_requirements,
      all_met: unmet_requirements.empty?
    }
  end

  private

  def calculate_requirements_for(target_tl)
    case target_tl
    when 1
      calculate_tl1_requirements
    when 2
      calculate_tl2_requirements
    when 3
      calculate_tl3_requirements
    when 4
      calculate_tl4_requirements
    else
      []
    end
  end
  
  def calculate_tl1_requirements
    [
      { id: 'topics_entered', name: I18n.t("trust_level_progress.tl1.topics_entered"), required: SiteSetting.tl1_requires_topics_entered, current: @user_stat.topics_entered, met: @user_stat.topics_entered >= SiteSetting.tl1_requires_topics_entered },
      { id: 'posts_read', name: I18n.t("trust_level_progress.tl1.posts_read"), required: SiteSetting.tl1_requires_posts_read, current: @user_stat.posts_read_count, met: @user_stat.posts_read_count >= SiteSetting.tl1_requires_posts_read },
      { id: 'time_spent', name: I18n.t("trust_level_progress.tl1.time_spent"), required: SiteSetting.tl1_requires_time_spent_mins, current: (@user_stat.time_read / 60.0).round, met: (@user_stat.time_read / 60) >= SiteSetting.tl1_requires_time_spent_mins }
    ]
  end

  def calculate_tl2_requirements
    [
      { id: 'days_visited', name: I18n.t("trust_level_progress.tl2.days_visited"), required: SiteSetting.tl2_requires_days_visited, current: @user_stat.days_visited, met: @user_stat.days_visited >= SiteSetting.tl2_requires_days_visited },
      { id: 'likes_given', name: I18n.t("trust_level_progress.tl2.likes_given"), required: SiteSetting.tl2_requires_likes_given, current: @user_stat.likes_given, met: @user_stat.likes_given >= SiteSetting.tl2_requires_likes_given },
      { id: 'likes_received', name: I18n.t("trust_level_progress.tl2.likes_received"), required: SiteSetting.tl2_requires_likes_received, current: @user_stat.likes_received, met: @user_stat.likes_received >= SiteSetting.tl2_requires_likes_received },
      { id: 'topics_replied_to', name: I18n.t("trust_level_progress.tl2.topics_replied_to"), required: SiteSetting.tl2_requires_topics_replied_to, current: @user_stat.topics_replied_to, met: @user_stat.topics_replied_to >= SiteSetting.tl2_requires_topics_replied_to }
    ]
  end

  def calculate_tl3_requirements
    [{ id: 'tl3_placeholder', name: "Trust Level 3 requirements are complex and calculated over time.", required: 'N/A', current: 'N/A', met: false }]
  end

  def calculate_tl4_requirements
    [{ id: 'tl4_placeholder', name: "Trust Level 4 requirements are complex and calculated over time.", required: 'N/A', current: 'N/A', met: false }]
  end
end
