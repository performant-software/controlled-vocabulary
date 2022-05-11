require_relative "lib/controlled_vocabulary/version"

Gem::Specification.new do |spec|
  spec.name        = "controlled_vocabulary"
  spec.version     = ControlledVocabulary::VERSION
  spec.authors     = ["Performant Software Solutions"]
  spec.email       = ["derek@performantsoftware.com"]
  spec.homepage    = "https://github.com/performant-software/controlled-vocabulary"
  spec.summary     = "Making dropdown configuration easy since 2022."
  spec.description = "A simple engine for management and retrieval of controlled vocabularies."
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0.3.2", "< 8"
  spec.add_dependency "pagy", "~> 5.10"
  spec.add_dependency "resource_api"
end
