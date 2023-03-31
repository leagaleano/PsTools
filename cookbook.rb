dir_obj = node['my_cookbook']['directory_object']

# Create the directory
directory dir_obj['path'] do
  recursive true
  action :create
end

# Add allow permissions to the directory
if dir_obj['rights'] && dir_obj['rights'].any?
  dir_obj['rights'].each do |right|
    windows_permissions dir_obj['path'] do
      user right['user']
      rights right['rights']
      type :allow
      recursive true
      action :create
    end
  end
end

# Add deny permissions to the directory
if dir_obj['deny_rights'] && dir_obj['deny_rights'].any?
  dir_obj['deny_rights'].each do |right|
    windows_permissions dir_obj['path'] do
      user right['user']
      rights right['rights']
      type :deny
      recursive true
      action :create
    end
  end
end