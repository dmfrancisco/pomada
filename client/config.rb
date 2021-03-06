###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end


###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end


# CSS directory
set :css_dir, "css"

# JS directory
set :js_dir, "js"

# Images directory
# set :images_dir, "alternative_image_directory"


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"

  # Gzip text files
  # activate :gzip
  # See https://gist.github.com/2200790
  # and http://guides.rubyonrails.org/v3.1.0/asset_pipeline.html#server-configuration

  # Pretty URLs (Directory Indexes)
  # activate :directory_indexes
  # page "/404.html", :directory_index => false
  # page "/500.html", :directory_index => false
end


after_configuration do
  # Add CSS directory to the Less compiler
  # Less.paths << File.join(source_dir, css_dir)

  # Add all subdirectories inside the CSS folder to the Less compiler
  Dir.glob(File.join(source_dir, css_dir, "**/")).each do |dir|
    Less.paths << File.expand_path(dir)
  end
end
