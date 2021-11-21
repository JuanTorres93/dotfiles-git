import os

home = os.path.expanduser("~")
repository_name = "dotfiles-git"
repository_dir = home + "/" + repository_name

# List of files/directories that are not wanted to be soft-linked
items_to_exclude = [".git",
                    ".emacs.d",
                    "blender-nvidia.org",
                    "README.md",
                    "Install_from_arch_based_distro",
                    "SoftLinkFiles",
                    "SoftLinkFiles.py",
                    "ArchSetUp_RunMeFromMyDirectory.sh"]

items_in_repository = os.listdir(repository_dir)


def link_file_to_homonymous_location(file):
    destination_path = file.replace(repository_name + "/", "")

    if os.path.exists(destination_path) or os.path.islink(destination_path):
        os.remove(destination_path)

    destination_path_members = destination_path.split("/")
    destination_path_members.pop()
    parent_directories = "/".join(destination_path_members)

    os.makedirs(parent_directories, exist_ok=True)

    os.symlink(file, destination_path)


def link_files_in_directory(directory):
    items_in_directory = os.listdir(directory)
    for item in items_in_directory:
        path_to_item = directory + "/" + item
        # If the item is a directory
        if os.path.isdir(path_to_item):
            link_files_in_directory(path_to_item)
        # If the item is a file
        else:
            link_file_to_homonymous_location(path_to_item)


for item in items_in_repository:
    if item not in items_to_exclude:
        path_to_item = repository_dir + "/" + item
        # If the item is a directory
        if os.path.isdir(path_to_item):
            link_files_in_directory(path_to_item)
        # If the item is a file
        else:
            link_file_to_homonymous_location(path_to_item)
