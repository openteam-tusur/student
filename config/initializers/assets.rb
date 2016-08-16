# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'uppod')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w(
  manage/spa.js
  403.png
  404.png
  500.png
  502.png
  errors.css
  galleria/src/themes/classic/classic-loader.gif
  galleria/themes/classic/galleria.classic.css
  galleria/themes/classic/galleria.classic.js
  html5.js
  mail.png
  placemark.png
  respond.js
  tusur_logotype.png
)
