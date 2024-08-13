class ProductDescriptionGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "product_description",
    description: "Generate product descriptions",
    attributes: [
      { name: "short_description", description: "A brief one-sentence description of the product" },
      { name: "long_description", description: "A detailed paragraph describing the product" },
      { name: "key_features", description: "A comma-separated list of key product features" },
      { name: "target_audience", description: "A brief description of the target audience for this product" }
    ]

  def initialize(product_name:, product_category:)
    @product_name = product_name
    @product_category = product_category
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are a skilled product copywriter. Create compelling product descriptions for the following:

    Product Name: #{@product_name}
    Product Category: #{@product_category}

    Please provide the following:
    1. A brief one-sentence description of the product
    2. A detailed paragraph describing the product
    3. A comma-separated list of key product features
    4. A brief description of the target audience for this product
    PROMPT
  end
end
