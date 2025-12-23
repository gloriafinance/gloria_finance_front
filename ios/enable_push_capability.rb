require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
entitlements_path = 'Runner/Runner.entitlements'

project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Add entitlements file to project
group = project.main_group.find_subpath('Runner', false)
file_ref = group.files.find { |f| f.path == 'Runner.entitlements' }
unless file_ref
  file_ref = group.new_file('Runner.entitlements')
  puts "Added Runner.entitlements to file references"
end

# Update build settings for all configurations
target.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = entitlements_path
  puts "Updated CODE_SIGN_ENTITLEMENTS for #{config.name}"
end

project.save
puts "Project saved"
