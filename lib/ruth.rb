require 'ruth/common'
require "ruth/version"
require "ruth/watcher"
require "ruth/housekeeper"
require "ruth/watched_file_getter"
require 'ruth/notification'
require 'ruth/hasher'
require 'ruth/baseline'
require 'ruth/persist'
require 'ruth/different'
require 'ruth/logger'

# The backend for this should be a REST API that will accept the posts of hashes
# in a db. It should serve up the baseline to the remote service and provide
# search for a hash to users.
module Ruth
  include Common
end
