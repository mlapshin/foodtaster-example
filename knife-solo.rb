app_path = File.dirname(__FILE__)

file_cache_path           "#{app_path}"
data_bag_path             "#{app_path}/data_bags"
encrypted_data_bag_secret "#{app_path}/data_bag_key"
cookbook_path             [ "#{app_path}/site-cookbooks", "#{app_path}/cookbooks" ]
role_path                 "#{app_path}/roles"

knife[:aws_access_key_id]     = ":)"
knife[:aws_secret_access_key] = ":)"
