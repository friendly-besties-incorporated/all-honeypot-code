This folder contains files for the creation of the honeypot templates. None of the honeypots created with this script should be actually run - only copied.

## main_template_creation
Main script for creating the template honeypot! Run with name of template and the website it should mount

Names of templates: 
* swipe_t
* it_t
* pwd_t
* blank_t
* control_t

## Called within main_template_creation:
### setup_apache
Setps up apache for the honypot. Web page gets added here.

### poison_downloads
Poisons curl and wget.

### add_honey
Adds the shared honey/system things.

## /poisoned_versions
Folder for poisoned versions of commands

## /honey
Folder for any honey that you need to use in add_honey
