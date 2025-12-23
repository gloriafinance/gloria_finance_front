require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
file_name = 'GoogleService-Info.plist'
file_path = "Runner/#{file_name}"

project = Xcodeproj::Project.open(project_path)
group = project.main_group.find_subpath('Runner', false)
target = project.targets.first

# Check if file is already in the project
file_ref = group.files.find { |f| f.path == file_name }

if file_ref
  puts "#{file_name} already exists in project."
else
  # Add file to the group
  file_ref = group.new_file(file_name)
  puts "Added #{file_name} to file references."
end

# Check if file is in the target's resources phase
resources_phase = target.resources_build_phase
build_file = resources_phase.files.find { |f| f.file_ref == file_ref }

if build_file
  puts "#{file_name} already in build phase."
else
  resources_phase.add_file_reference(file_ref)
  puts "Added #{file_name} to #{target.name} target resources."
end

project.save
puts "Project saved."
