require 'yaml'

class AppConfig  
  def self.load
    config_file = File.join(Merb.root, "config", "application.yml")

    if File.exists?(config_file)
      config = YAML.load(File.read(config_file)) #[Merb.environment]

      config.keys.each do |key|
        Merb::Config[key.to_sym] = config[key]
      end
    end
    
  end
end
