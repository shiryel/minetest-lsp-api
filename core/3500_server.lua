---@meta

--- Request for
--- server shutdown. Will display `message` to clients.
--- * `reconnect` == true displays a reconnect button
--- * `delay` adds an optional delay (in seconds) before shutdown.
--- Negative delay cancels the current active shutdown.
--- Zero delay triggers an immediate shutdown.
---@param message? string Will display `message` to clients.
---@param reconnect? boolean Displays a reconnect button to players.
---@param delay? any Adds an optional delay (in seconds) before shutdown. Negative delay cancels the current active shutdown. Zero delay triggers an immediate shutdown.
function core.request_shutdown(message, reconnect, delay) end


--- Cancel current delayed shutdown
function core.cancel_shutdown_requests() end


--- * Returns the server status string when a player joins or when the command
--- `/status` is called. Returns `nil` or an empty string when the message is
--- disabled.
--- * `joined`: Boolean value, indicates whether the function was called when
--- a player joined.
--- * This function may be overwritten by mods to customize the status message.
---@param name string
---@param joined any Indicates whether the function was called when a player joined.
---@return string
function core.get_server_status(name, joined) end


--- Returns the server uptime in seconds
---@return integer
function core.get_server_uptime() end


--- Returns the current maximum lag
--- of the server in seconds or nil if server is not fully loaded yet
---@return number
function core.get_server_max_lag() end


--- Remove player from database (if they are not
--- connected).
--- * As auth data is not removed, `core.player_exists` will continue to
--- return true. Call the below method as well if you want to remove auth
--- data too.
--- * Returns a code (0: successful, 1: no such player, 2: player is connected)
---@param name string
---@return 0|1|2 (0: successful, 1: no such player, 2: player is connected).
function core.remove_player(name) end


--- Remove player authentication data
--- * Returns boolean indicating success (false if player nonexistent)
---@param name string
---@return boolean
function core.remove_player_auth(name) end


---@class dynamic_add_media_options
local dynamic_add_media_options = {}

---Path to a media file on the filesystem.
---@type string
dynamic_add_media_options.filepath = nil

---Name of the player the media should be sent to instead of all players (optional).
---@type string
dynamic_add_media_options.to_player = nil

---Marks the media as ephemeral, it will not be cached on the client (optional, default: false).
---@type boolean
dynamic_add_media_options.ephemeral = nil

--- * `options`: table containing the following parameters
--- * `filename`: name the media file will be usable as
--- (optional if `filepath` present)
--- * `filepath`: path to the file on the filesystem [*]
--- * `filedata`: the data of the file to be sent [*]
--- * `to_player`: name of the player the media should be sent to instead of
--- all players (optional)
--- * `ephemeral`: boolean that marks the media as ephemeral,
--- it will not be cached on the client (optional, default false)
--- * Exactly one of the parameters marked [*] must be specified.
--- * `callback`: function with arguments `name`, which is a player name
--- * Pushes the specified media file to client(s). (details below)
--- The file must be a supported image, sound or model format.
--- Dynamically added media is not persisted between server restarts.
--- * Returns false on error, true if the request was accepted
--- * The given callback will be called for every player as soon as the
--- media is available on the client.
--- * Details/Notes:
--- * If `ephemeral`=false and `to_player` is unset the file is added to the media
--- sent to clients on startup, this means the media will appear even on
--- old clients if they rejoin the server.
--- * If `ephemeral`=false the file must not be modified, deleted, moved or
--- renamed after calling this function.
--- * Regardless of any use of `ephemeral`, adding media files with the same
--- name twice is not possible/guaranteed to work. An exception to this is the
--- use of `to_player` to send the same, already existent file to multiple
--- chosen players.
--- * You can also call this at startup time. In that case `callback` MUST
--- be `nil` and you cannot use `ephemeral` or `to_player`, as these logically
--- do not make sense.
--- * Clients will attempt to fetch files added this way via remote media,
--- this can make transfer of bigger files painless (if set up). Nevertheless
--- it is advised not to use dynamic media for big media files.
---@param options dynamic_add_media_options
---@param callback fun(name: string)
---@return boolean
function core.dynamic_add_media(options, callback) end