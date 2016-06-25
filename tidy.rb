#!/usr/bin/ruby


require 'ftools'


# Use ending to tell Emacs what language mode to use.
ending = ARGV[0]
raise('No ending specified') if (ending.nil? || ending.empty?)


# Handle selection (less useful, probably) or full file.
tmp_file = "/tmp/textmate-tidy.#{$$}.#{ending}"
selected = ENV['TM_SELECTED_TEXT'] || ''
if (selected.empty?)
    raise('No selected text or file.') if (ENV['TM_FILEPATH'].empty?)
    File.copy(ENV['TM_FILEPATH'], tmp_file)
else
    File.open(tmp_file, 'w') { |fout| fout.print selected }
end


# Do the indentation, loading user Emacs file (to handle user indent customizations).
user = ENV['USER'] || ''
user_opt = "-u #{user}" unless (user.empty?)
cmd = "emacs -batch #{user_opt} '#{tmp_file}' -eval '(indent-region (point-min) (point-max) nil)' -eval '(untabify (point-min) (point-max))' -f save-buffer &> /dev/null"
system(cmd) || raise("Failed to indent with Emacs.")
system("cat #{tmp_file}")
File.delete(tmp_file)
