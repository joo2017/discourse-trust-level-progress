# frozen_string_literal: true

# name: discourse-trust-level-progress
# about: Allows users to see their progress towards the next trust level.
# version: 1.1.0
# authors: Your Name

after_initialize do
  require_relative 'lib/trust_level_progress_calculator'
  require_relative 'app/controllers/trust_level_progress_controller'

  Discourse::Application.routes.prepend do
    get "/trust-level-progress/:username" => "trust_level_progress#show", constraints: { username: RouteFormat.username }
  end

  add_to_class(:user, :can_see_trust_level_progress?) do
    return true if id == current_user&.id
  end

  Discourse.UserNavItem.add(
    id: :trust_level_progress,
    name: "trust_level_progress.nav_item_name",
    component: "user-trust-level-progress",
    href: ->(user) { "/u/#{user.username_lower}/summary" },
    visible: ->(user) { user.can_see_trust_level_progress? }
  )
end

# We have removed the following lines because they are deprecated and cause errors:
# register_asset "assets/javascripts/discourse/templates/components/user-trust-level-progress.hbs"
# register_asset "assets/javascripts/discourse/components/user-trust-level-progress.js"
# The build system will now automatically include these assets.
