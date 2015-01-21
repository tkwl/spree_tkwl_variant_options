FactoryGirl.define do

  factory :product_with_variants, :parent => :base_product do
    after(:create) { |product|
      size = Spree::OptionType.find_by_name('size') || create(:option_type, name: 'size', presentation: 'Size', position: 1)
      color = Spree::OptionType.find_by_name('color') || create(:option_type, name: 'color', presentation: 'Color', position: 2)

      sizes = %w(Small Medium Large X-Large).map{|i| create(:option_value, :name => i.downcase, :presentation => i, :option_type => size) }
      colors = %w(Red Green Blue Yellow Purple Gray Black White).map{|i|
        create(:option_value, :name => i.downcase, :presentation => i, :option_type => color)
      }
      product.variants = sizes.map{|i| colors.map{|j| create(:variant, :product => product, :option_values => [i, j]) }}.flatten
      product.option_types = Spree::OptionType.where(:name => %w(size color))
    }
  end

  # factory :variant, :class => Spree::Variant do
  #   product { Spree::Product.last || Factory.create(:product) }
  #   option_values { [OptionValue.last || Factory.create(:option_value)] }
  #   sequence(:sku) { |n| "ROR-#{1000 + n}" }
  #   sequence(:price) { |n| 19.99 + n }
  #   cost_price 17.00
  #   count_on_hand 10
  # end

  # factory :option_type, :class => Spree::OptionType do
  #   presentation "Size"
  #   name { presentation.downcase }
  #   sequence(:position) {|n| n }
  # end

  # factory :option_value, :class => Spree::OptionValue do
  #   presentation "Large"
  #   name { presentation.downcase }
  #   option_type { Spree::OptionType.last || Factory.create(:option_type) }
  #   #sequence(:position) {|n| n }
  # end

end
