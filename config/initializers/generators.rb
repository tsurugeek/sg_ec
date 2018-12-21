Rails.application.config.generators do |g|
  g.stylesheets false
  g.javascripts false
  g.helper false
  g.template_engine :haml
  g.test_framework :rspec,
                   fixtures: true,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   controller_specs: false,
                   request_specs: true
  g.fixture_replacement :factory_bot, dir: "spec/factories"
end
