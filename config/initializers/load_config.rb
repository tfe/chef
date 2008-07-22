# Load our YAML app-wide config file (http://railscasts.com/episodes/85)
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
