if [ ! $# -eq 2 ]
then
  echo "Usage: ./process_complete_container [container name] [folder name]"
  exit 1
fi

# This file will take in a container and process any files that are on it. For example, moving the
# downloaded files to the sandbox, stuff like that.

# Name the folder "folder name", wherever you end up putting it, so that we can match mitm logs to 
