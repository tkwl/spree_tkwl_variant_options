Spree::Admin::ImagesController.class_eval do
  alias_method :super_load_data, :load_data

  # Called in a before_filter
  def load_data
    super_load_data

    @grouped_option_values ||= @product.option_values.group_by(&:option_type)
    @grouped_option_values.sort_by { |option_type, option_values| option_type.position }
  end

  # Called in a create.before
  def set_viewable
    viewable_id = params[:image][:viewable_id]

    if viewable_id.is_a?(Hash)
      @product.errors.add(:attachment, 'Erro')
      option_values_array = viewable_id.map {|option_type, option_values| option_values.map(&:to_i) }
      option_values_combinations = option_values_array.shift
      option_values_array.each do |option_value|
        option_values_combinations = option_values_combinations.product(option_value)
      end
      option_values_combinations = option_values_combinations.map(&:flatten) if option_values_combinations.count > 1

      @product.variants.each do |variant|
        option_values_combinations.each do |ov_combination|
          variant_option_ids = variant.option_values.pluck(:id)

          if ([ov_combination].flatten - variant_option_ids).empty?
            create_image(variant, permitted_resource_params)
          end
        end
      end
    else
      viewable_id = params[:master_option] if params[:master_option]
      @image.viewable_type = 'Spree::Variant'
      @image.viewable_id = viewable_id
    end
  end

  private

  def create_image(variant, image_attributes)
    image = Spree::Image.new(permitted_resource_params)
    image.viewable_type = 'Spree::Variant'
    image.viewable_id = variant.id
    variant.images << image
    variant.save
  end
end