Spree::Admin::OptionValuesController.class_eval do
  def detach_image
    @option_value = Spree::OptionValue.find(params[:id])
    @option_value.image = nil
    @option_value.save
    redirect_to edit_admin_option_type_url(@option_value.option_type)
  end
end
