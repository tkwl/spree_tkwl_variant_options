module ProductExtensions
  extend ActiveSupport::Concern

  included do
    singleton_class.prepend ClassMethods
    prepend InstanceMethods
  end

  module ClassMethods

  end

  module InstanceMethods
    def show
      super
      @main_option_value = params[SpreeVariantOptions::VariantConfig.main_option_type_label]
    end
  end

end