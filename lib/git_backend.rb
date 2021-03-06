require "fileutils"

class GitBackend
  class << self
    # Creates a new bare Git repository at +path+
    # sets git-daemon-export-ok if +set_export_ok+ is true (default)
    def create(repos_path, set_export_ok = true)
      FileUtils.mkdir_p(repos_path, :mode => 0750)
      Dir.chdir(repos_path) do |path| 
        Git.init(path, :repository => path)
        FileUtils.touch(File.join(path, "git-daemon-export-ok")) if set_export_ok
      end
    end
    
    # Clones a new bare Git repository at +target-path+ from +source_path+
    # sets git-daemon-export-ok if +set_export_ok+ is true (default)
    def clone(target_path, source_path, set_export_ok = true)
      Git.clone(source_path, target_path, :bare => true)
      FileUtils.touch(File.join(target_path, "git-daemon-export-ok")) if set_export_ok
    end
    
    def delete!(repos_path)
      FileUtils.rm_rf(repos_path)
    end
    
    def repository_has_commits?(repos_path)
      Dir[File.join(repos_path, "refs/heads/*")].size > 0
    end
  end
end