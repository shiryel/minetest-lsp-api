---@diagnostic disable: missing-return
---@meta
---Item handling
----------------

-- Returns a string for making an image of a cube (useful as an item image).
---@param img1 string
---@param img2 string
---@param img3 string
---@return string
function core.inventorycube(img1, img2, img3) end

-- Returns the position of a `pointed_thing` or `nil` if the `pointed_thing`
-- does not refer to a node or entity.
--
-- If the optional `above` parameter is true and the `pointed_thing` refers
-- to a node, then it will return the `above` position of the `pointed_thing`.
---@param pointed_thing mt.PointedThing
---@param above boolean|nil
---@return mt.Vector
function core.get_pointed_thing_position(pointed_thing, above) end

-- Convert a vector to a facedir value,
-- used in `param2` for `paramtype2="facedir"`.
--
-- Passing something non-`nil`/`false` for the optional second parameter
-- causes it to take the `y` component into account.
---@param dir mt.Vector
---@param is6d boolean|nil
---@return mt.NodeParam
function core.dir_to_facedir(dir, is6d) end

-- Convert a facedir back into a vector aimed directly out the "back" of a node.
---@param facedir mt.NodeParam
---@return mt.Vector
function core.facedir_to_dir(facedir) end

-- Convert a vector to a 4dir value, used in `param2` for `paramtype2="4dir"`.
---@param dir mt.Vector
---@return string
function core.dir_to_fourdir(dir) end

-- Convert a 4dir back into a vector aimed directly out the "back" of a node.
---@param fourdir string
---@return mt.Vector
function core.fourdir_to_dir(fourdir) end

-- Convert a vector to a wallmounted value, used for `paramtype2="wallmounted"`.
---@param dir mt.Vector
---@return mt.NodeParam
function core.dir_to_wallmounted(dir) end

-- Convert a wallmounted value back into a vector
-- aimed directly out the "back" of a node.
---@param wallmounted mt.ParamType2
---@return mt.Vector
function core.wallmounted_to_dir(wallmounted) end

-- Convert a vector into a yaw (angle).
---@param dir mt.Vector
---@return number
function core.dir_to_yaw(dir) end

-- Convert yaw (angle) to a vector.
---@param yaw number
---@return  mt.Vector
function core.yaw_to_dir(yaw) end

-- Returns a boolean. Returns `true` if the given `paramtype2` contains
-- color information (`color`, `colorwallmounted`, `colorfacedir`, etc.).
---@param ptype mt.ParamType2
---@return boolean
function core.is_colored_paramtype(ptype) end

-- Removes everything but the color information from the given `param2` value.
--
-- Returns `nil` if the given `paramtype2` does not contain color information.
---@param param2 mt.NodeParam
---@param paramtype2 mt.ParamType2
---@return mt.NodeParam|nil
function core.strip_param2_color(param2, paramtype2) end

-- Returns list of itemstrings that are dropped by `node` when dug
-- with the item `toolname` (not limited to tools).
---@param node mt.Node|string Node as table or node name.
---@param toolname string|nil Name of the item used to dig.
---@return mt.ItemString[]
function core.get_node_drops(node, toolname) end

-- Used in `core.get_craft_result` and `core.get_craft_recipe`.
---@class mt.CraftInput
---@field method "normal"|"cooking"|"fuel"
---@field width number|nil
---@field items mt.Item[]

-- Used in `core.get_craft_result`.
---@class mt.CraftOutput
---@field item mt.ItemStack Can be empty.
---@field time number
---@field replacements mt.ItemStack[]

---@param input mt.CraftInput
---@return mt.CraftOutput output
---@return mt.CraftInput decremented_input
function core.get_craft_result(input) end

-- Returns last registered recipe for output item (node).
---@param output mt.Node|mt.ItemString
---@return mt.CraftInput
function core.get_craft_recipe(output) end

-- Example result for `"default:gold_ingot"` with two recipes:
--
-- ```lua
-- {
--     {
--         method = "cooking", width = 3,
--         output = "default:gold_ingot", items = {"default:gold_lump"}
--     },
--     {
--         method = "normal", width = 1,
--         output = "default:gold_ingot 9", items = {"default:goldblock"}
--     }
-- }
-- ```
---@class mt.AllCraftRecipes:mt.CraftInput
---@field output mt.ItemString

---@param item mt.Node
---@return mt.AllCraftRecipes|nil
function core.get_all_craft_recipes(item) end

-- Handles drops from nodes after digging:
-- Default action is to put them into digger's inventory.
--
-- Can be overridden to get different functionality
-- (e.g. dropping items on ground).
---@param pos mt.Vector
---@param drops mt.ItemString[]
---@param digger mt.ObjectRef
function core.handle_node_drops(pos, drops, digger) end

-- Creates an item string which contains palette index information
-- for hardware colorization. You can use the returned string
-- as an output in a craft recipe.
---@param item mt.Item
---@param palette_index integer Added to the item stack.
---@return mt.ItemString
function core.itemstring_with_palette(item, palette_index) end

-- Creates an item string which contains static color information
-- for hardware colorization. Use this method if you wish to colorize
-- an item that does not own a palette. You can use the returned string
-- as an output in a craft recipe.
---@param item mt.Item
---@param colorstring mt.ColorString The new color of the item stack.
---@return mt.ItemString
function core.itemstring_with_color(item, colorstring) end

---Defaults for the `on_place`, `on_drop`, `on_punch` and `on_dig`
------------------------------------------------------------------

-- Default `on_place` callback for nodes.
--
-- Place item as a node.
--
-- * If `prevent_after_place` set to `true`, `after_place_node` is not called
--   for the newly placed node to prevent a callback and placement loop.
---@param itemstack mt.Item
---@param placer mt.ObjectRef
---@param pointed_thing mt.PointedThing
---@param param2 mt.NodeParam|nil Overrides `facedir` and wallmounted `param2`.
---@param prevent_after_place boolean|nil
---@return mt.ItemStack, mt.Vector|nil position
function core.item_place_node(
  itemstack,
  placer,
  pointed_thing,
  param2,
  prevent_after_place
)
end

-- Place item as-is.
--
-- - **Note**: This function is deprecated and will never be called.
---@param itemstack mt.Item
---@param placer mt.ObjectRef
---@param pointed_thing mt.PointedThing
---@return mt.ItemStack leftover
---@deprecated
function core.item_place_object(itemstack, placer, pointed_thing) end

-- Default `on_place` callback for items.
--
-- Wrapper that calls `core.item_place_node` if appropriate.
-- Calls `on_rightclick` of `pointed_thing.under` if defined instead.
--
-- **Note**: is not called when wielded item overrides `on_place`.
---@param itemstack mt.Item
---@param placer mt.ObjectRef
---@param pointed_thing mt.PointedThing
---@param param2 mt.NodeParam|nil Overrides facedir and wallmounted `param2`.
---@return mt.ItemStack, mt.Vector|nil position
function core.item_place(itemstack, placer, pointed_thing, param2) end

-- Runs callbacks registered by `core.register_on_item_pickup` and adds
-- the item to the picker's `"main"` inventory list.
--
-- * Parameters are the same as in `on_pickup`.
---@param itemstack mt.ItemStack
---@param picker mt.ObjectRef
---@param pointed_thing mt.PointedThing
---@param time_from_last_punch number
---@param ... any
---@return mt.ItemStack leftover
function core.item_pickup(
  itemstack,
  picker,
  pointed_thing,
  time_from_last_punch,
  ...
)
end

-- Default `on_drop` callback.
--
-- Drop the item.
---@param itemstack mt.Item
---@param dropper mt.ObjectRef|nil
---@param pos mt.Vector
---@return mt.ItemStack leftover
function core.item_drop(itemstack, dropper, pos) end

-- Default `on_eat` callback.
--
-- - `replace_with_item` is the itemstring which is added to the inventory. If
--   the player is eating a stack and `replace_with_item` doesn't fit onto
--   the eaten stack, then the remainings go to a different spot, or are dropped.
--
-- Returns a function wrapper for `core.do_item_eat`.
---@param hp_change number
---@param replace_with_item mt.Item|nil
---@return fun(itemstack:mt.Item, user:mt.ObjectRef, pointed_thing:mt.PointedThing)
function core.item_eat(hp_change, replace_with_item) end

-- Default `on_punch` callback.
--
-- Calls functions registered by `core.register_on_punchnode()`.
---@param pos mt.Vector
---@param node mt.Node
---@param puncher mt.ObjectRef
---@param pointed_thing mt.PointedThing
function core.node_punch(pos, node, puncher, pointed_thing) end

-- Default `on_dig` callback.
--
-- - Checks if node can be dug, puts item into inventory, removes node.
-- - Calls functions registered by `core.registered_on_dignodes()`.
---@param pos mt.Vector
---@param node mt.Node
---@param digger mt.ObjectRef
function core.node_dig(pos, node, digger) end