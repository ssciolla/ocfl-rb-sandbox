require "ocfl"
# ??
require "pathname"

storage_path = File.join(File.dirname(__dir__), "storage")
staging_path = File.join(storage_path, "staging")
root_path = File.join(storage_path, "root")

FileUtils.rm_r(root_path) if File.exist?(root_path)

# Set up storage root
storage_root = OCFL::StorageRoot.new(base_directory: root_path)
storage_root.save
p storage_root.valid?

# Add an object in the first version
first_object = storage_root.object("bc123df4567")
first_version = first_object.begin_new_version
first_version.copy_recursive(File.join(staging_path, "1"))
# first_version.copy_file(File.join(staging_path, "1", "a.txt"))
# first_version.copy_file(File.join(staging_path, "1", "b.txt"))
first_version.save

# Delete a file in the second version
second_version = first_object.begin_new_version
second_version.delete_file("b.txt")
second_version.save

# Replace a file in the third version
third_version = first_object.begin_new_version
third_version.copy_file(File.join(staging_path, "new_files", "v3", "a.txt"))
third_version.save
