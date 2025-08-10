# frozen_string_literal: true

# We use with_plugin to ensure this code runs within our plugin's context.
with_plugin("discourse-trust-level-progress") do

  # This code will now run at a later, safer point in the boot process.
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

  # We also move the route definition here to be safe.
  Discourse::Application.routes.prepend do
    get "/trust-level-progress/:username" => "trust_level_progress#show", constraints: { username: RouteFormat.username }
  end
end
