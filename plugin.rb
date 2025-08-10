# frozen_string_literal: true

# name: discourse-trust-level-progress
# about: Allows users to see their progress towards the next trust level.
# version: 1.2.0
# authors: Your Name

# No enabled_site_setting is needed as this plugin is always on.

after_initialize do
  # We only load the core logic files here.
  # All the initialization logic has been moved to a safer place.
  require_relative '../lib/trust_level_progress_calculator'
  require_relative '../app/controllers/trust_level_progress_controller'
end
