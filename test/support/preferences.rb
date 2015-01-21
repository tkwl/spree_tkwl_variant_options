def reset_spree_variant_options_preferences(&config_block)
  Spree::Preferences::Store.instance.persistence = false
  Spree::Preferences::Store.instance.clear_cache

  config = Rails.application.config.spree.variant_preferences
  configure_spree_variant_options_preferences &config_block if block_given?
end

def configure_spree_variant_options_preferences
  config = Rails.application.config.spree.variant_preferences
  yield(config) if block_given?
end

