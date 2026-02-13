#include <cstdlib>
#include <filesystem>
#include <iostream>
#include <unordered_map>

// set this to false if you want to run the script
static const bool testing_mode = true;

void print_usage() {
  std::cerr << "Usage -" << std::endl;
  std::cerr << " Write from git repo to home directory:" << std::endl;
  std::cerr << "  cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake "
               "--build . && ./dotfiles --to_home; cd ../"
            << std::endl;
  std::cerr << "\n";
  std::cerr << " Write from home directory to git repo:" << std::endl;
  std::cerr << "  cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake "
               "--build . && ./dotfiles --to_repo; cd ../"
            << std::endl;
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    print_usage();
    exit(1);
  }
  bool write_to_home = false;
  if (std::string(argv[1]) == "--to_home") {
    write_to_home = true;
  }
  if (!write_to_home && std::string(argv[1]) != "--to_repo") {
    print_usage();
    exit(1);
  }
  std::cout << "Writing to " << (write_to_home ? "home" : "repo") << std::endl;
  // Only going to care about Linux and macOS since those are the only systems I
  // use currently.
  // TODO: add support for Windows.
  const char *home_dir = std::getenv("HOME");
  const std::filesystem::path &home_path(std::move(home_dir));

  // we are going to fill in this map with the source paths values (in git repo)
  std::unordered_map<std::string, std::filesystem::path> config_files{
      {".emacs", ""}, {".emacs.custom.el", ""}, {".tmux.conf", ""}};

  const auto &curr_parent_path = std::filesystem::current_path().parent_path();

  for (const auto &dir_entry :
       std::filesystem::directory_iterator(curr_parent_path)) {
    if (config_files.find(dir_entry.path().filename()) != config_files.end()) {
      config_files[dir_entry.path().filename()] = std::move(dir_entry.path());
    }
  }

  for (const auto &dir_entry : std::filesystem::directory_iterator(home_path)) {
    const auto &dest_filename = dir_entry.path().filename();
    if (config_files.find(dest_filename) != config_files.end()) {
      if (write_to_home) {
	std::cout << "Copying to: " << dir_entry.path()
		  << " from: " << config_files[dest_filename] << std::endl;
      } else {
	std::cout << "Copying to: " << config_files[dest_filename]
		  << " from: " << dir_entry.path() << std::endl;
      }
      if (!testing_mode) {
        // from, to
        // we want update_existing because it only replaces the dotfile if
        // it is older than the one we're copy over. (this is definitely
        // desirable).
        std::cout << "Actually writing out changes.." << std::endl;
        if (write_to_home) {
          std::filesystem::copy_file(
              config_files[dest_filename], dir_entry.path(),
              std::filesystem::copy_options::update_existing);
        } else {
          std::filesystem::copy_file(
              dir_entry.path(), config_files[dest_filename],
              std::filesystem::copy_options::update_existing);
        }
      }
    }
  }
  if (testing_mode) {
    std::cout << "!! Reminder to set testing_mode if dry-run looked good"
              << std::endl;
    print_usage();
  }
}
