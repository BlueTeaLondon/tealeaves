require "spec_helper"

RSpec.describe "Suspend a new project with default configuration", type: :feature do
  before(:all) do
    drop_dummy_database
    clear_tmp_directory
    run_tealeaves
    setup_app_dependencies
  end

  it "uses custom Gemfile" do
    gemfile_file = IO.read("#{project_path}/Gemfile")
    expect(gemfile_file).to match(
      /^ruby "#{Tealeaves::RUBY_VERSION}"$/o
    )
    expect(gemfile_file).to match(
      /^gem "rails", "#{Tealeaves::RAILS_VERSION}"$/o
    )
  end

  it "ensures project specs pass" do
    Dir.chdir(project_path) do
      Bundler.with_unbundled_env do
        expect(`rake`).to include("0 failures")
      end
    end
  end

  it "includes the bundle:audit task" do
    Dir.chdir(project_path) do
      Bundler.with_unbundled_env do
        expect(`rails -T`).to include("rails bundle:audit")
      end
    end
  end

  it "creates .ruby-version from Tealeaves .ruby-version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end

  it "copies dotfiles" do
    expect(File).to exist("#{project_path}/.sample.env")
  end

  it "doesn't generate test directory" do
    expect(File).not_to exist("#{project_path}/test")
  end

  it "adds bin/setup file" do
    expect(File).to exist("#{project_path}/bin/setup")
  end

  it "makes bin/setup executable" do
    expect("bin/setup").to be_executable
  end

  it "adds bin/yarn file" do
    expect(File).to exist("#{project_path}/bin/yarn")
  end

  it "makes bin/setup executable" do
    expect("bin/yarn").to be_executable
  end

  it "adds support file for action mailer" do
    expect(File).to exist("#{project_path}/spec/support/action_mailer.rb")
  end

  it "adds support file for i18n" do
    expect(File).to exist("#{project_path}/spec/support/i18n.rb")
  end

  it "initializes ActiveJob to avoid memory bloat" do
    expect(File)
      .to exist("#{project_path}/config/initializers/active_job.rb")
  end

  it "raises on unpermitted parameters in all environments" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(
      /^ +config.action_controller.action_on_unpermitted_parameters = :raise$/
    )
  end

  it "adds explicit quiet_assets configuration" do
    result = IO.read("#{project_path}/config/application.rb")

    expect(result).to match(/^ +config.assets.quiet = true$/)
  end

  it "configures public_file_server.headers in production" do
    expect(production_config).to match(
      /^ +config.public_file_server.headers = {\n +"Cache-Control" => "public,/
    )
  end

  it "configures production environment to enforce SSL" do
    expect(production_config).to match(
      /^ +config.force_ssl = true/
    )
  end

  it "raises on missing translations in development and test" do
    [development_config, test_config].each do |environment_file|
      expect(environment_file).to match(
        /^ +config.i18n.raise_on_missing_translations = true$/
      )
    end
  end

  it "evaluates en.yml.erb" do
    locales_en_file = IO.read("#{project_path}/config/locales/en.yml")

    expect(locales_en_file).to match(/application: #{app_name.humanize}/)
  end

  it "configs simple_form" do
    expect(File).to exist("#{project_path}/config/initializers/simple_form.rb")
  end

  it "configs :test email delivery method for development" do
    expect(development_config)
      .to match(/^ +config.action_mailer.delivery_method = :file$/)
  end

  it "sets action mailer default host and asset host" do
    config_key = "config.action_mailer.asset_host"
    # rubocop:disable Lint/InterpolationCheck
    config_value =
      %q{"https://#{ENV\.fetch\("ASSET_HOST", ENV\.fetch\("APPLICATION_HOST"\)\)}}
    # rubocop:enable Lint/InterpolationCheck
    expect(production_config).to match(/#{config_key} = #{config_value}/)
  end

  it "uses APPLICATION_HOST, not HOST in the production config" do
    expect(production_config).to match(/"APPLICATION_HOST"/)
    expect(production_config).not_to match(/"HOST"/)
  end

  it "configures language in html element" do
    layout_path = "/app/views/layouts/application.html.erb"
    layout_file = IO.read("#{project_path}#{layout_path}")
    expect(layout_file).to match(/<html lang="en">/)
  end

  it "configures requests specs" do
    application_config = IO.read("#{project_path}/config/application.rb")

    expect(application_config).to match(
      /^ +generate.request_specs true$/
    )
  end

  it "configs active job queue adapter" do
    application_config = IO.read("#{project_path}/config/application.rb")

    expect(application_config).to match(/^ +config.active_job.queue_adapter = :sidekiq$/) &
      match(/^ +config.action_mailer.deliver_later_queue_name = nil$/) &
      match(/^ +config.action_mailbox.queues.routing = nil$/) &
      match(/^ +config.active_storage.queues.analysis = nil$/) &
      match(/^ +config.active_storage.queues.purge = nil$/) &
      match(/^ +config.active_storage.queues.mirror = nil$/)
    expect(test_config).to match(
      /^ +config.active_job.queue_adapter = :inline$/
    )
  end

  it "configs bullet gem in development" do
    expect(development_config).to match(/^ +Bullet.enable = true$/)
    expect(development_config).to match(/^ +Bullet.bullet_logger = true$/)
    expect(development_config).to match(/^ +Bullet.rails_logger = true$/)
    # prevent broken result of standard removing whitespaces
    expect(development_config).to_not match(/trueconfig/)
  end

  it "configs missing assets to raise in test" do
    expect(test_config).to match(
      /^ +config.assets.raise_runtime_errors = true$/
    )
  end

  it "removes comments and extra newlines from config files" do
    config_files = [
      IO.read("#{project_path}/config/application.rb"),
      IO.read("#{project_path}/config/environment.rb"),
      development_config,
      test_config,
      production_config
    ]

    config_files.each do |file|
      expect(file).not_to match(/^\s*#.*$/)
      expect(file).not_to eq(file.strip)
      expect(file).not_to match(%r{^$\n\n})
    end
  end

  it "copies factories.rb" do
    expect(File).to exist("#{project_path}/spec/factories.rb")
  end

  it "creates review apps setup script" do
    bin_setup_path = "#{project_path}/bin/setup_review_app"
    bin_setup = IO.read(bin_setup_path)

    expect(bin_setup).to include("PARENT_APP_NAME=#{app_name.dasherize}-staging")
    expect(bin_setup).to include("APP_NAME=#{app_name.dasherize}-staging-pr-$1")
    expect(bin_setup).to include("heroku ps:scale worker=1 --app $APP_NAME")
    expect(bin_setup).to include("heroku restart --app $APP_NAME")

    expect("bin/setup_review_app").to be_executable
  end

  it "creates deploy script" do
    bin_deploy_path = "#{project_path}/bin/deploy"
    bin_deploy = IO.read(bin_deploy_path)

    expect(bin_deploy).to include("git push")
    expect("bin/deploy").to be_executable
  end

  it "creates heroku application manifest file with application name in it" do
    app_json_file = IO.read("#{project_path}/app.json")

    expect(app_json_file).to match(/"name":\s*"#{app_name.dasherize}"/)
  end

  it "configures Timecop safe mode" do
    spec_helper = read_project_file(%w[spec spec_helper.rb])
    expect(spec_helper).to match(/Timecop.safe_mode = true/)
  end

  it "adds and configures a bundler strategy for css and js" do
    gemfile = read_project_file("Gemfile")

    expect(gemfile).to match(/cssbundling-rails/)
    expect(gemfile).to match(/jsbundling-rails/)
    expect(File).to exist("#{project_path}/postcss.config.js")
    expect(File).to exist("#{project_path}/package.json")
    expect(File).to exist("#{project_path}/bin/dev")
    expect(File).to exist("#{project_path}/app/assets/stylesheets/application.tailwind.css")
    expect(File).to exist("#{project_path}/app/javascript/application.ts")
  end

  it "imports css and js" do
    layout = read_project_file %w[app views layouts application.html.erb]

    expect(layout)
      .to include(%(<%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>))
    expect(layout)
      .to include(%(<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>))
  end

  it "loads security helpers" do
    layout = read_project_file %w[app views layouts application.html.erb]

    expect(layout)
      .to include(%(<%= csp_meta_tag %>))
    expect(layout)
      .to include(%(<%= csrf_meta_tags %>))
  end

  def app_name
    TestPaths::APP_NAME
  end

  def development_config
    @_development_config ||=
      read_project_file %w[config environments development.rb]
  end

  def test_config
    @_test_config ||= read_project_file %w[config environments test.rb]
  end

  def production_config
    @_production_config ||=
      read_project_file %w[config environments production.rb]
  end

  def read_project_file(path)
    IO.read(File.join(project_path, *path))
  end
end
