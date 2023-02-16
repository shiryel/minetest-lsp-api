---@meta
---Nodes
--------

---Nodes are the bulk data of the world: cubes and other things that take the
---space of a cube. Huge amounts of them are handled efficiently, but they
---are quite static.
---
---The definition of a node is stored and can be accessed by using
---
---    minetest.registered_nodes[node.name]
---
---Nodes are passed by value between Lua and the engine.
---They are represented by a table:
---
---    {name="name", param1=num, param2=num}
---
---`param1` and `param2` are 8-bit integers ranging from 0 to 255. The engine uses
---them for certain automated functions. If you don't use these functions, you can
---use them to store arbitrary values.
---@class mt.Node
---@field name string
---@field param1 integer
---@field param2 integer
local node = {}

---@class mt.MapNode:mt.Node
-- (alias `param1`): the probability of this node being placed (default: 255).
--
-- * A probability value of `0` or `1` means that node will never appear
--   (0% chance).
-- * A probability value of `254` or `255` means the node will always appear
--   (100% chance).
-- * If the probability value `p` is greater than `1`, then there is a
--   `(p / 256 * 100)` percent chance that node will appear when the schematic is
--   placed on the map.
---@field prob integer
-- Representing if the node should forcibly overwrite any previous contents (default: false).
---@field force_place boolean

---Node paramtypes
------------------

---The functions of `param1` and `param2` are determined by certain fields in the
---node definition.
---
---The function of `param1` is determined by `paramtype` in node definition.
---`param1` is reserved for the engine when `paramtype != "none"`.
---@alias mt.ParamType
---* The value stores light with and without sun in its lower and upper 4 bits
---  respectively.
---* Required by a light source node to enable spreading its light.
---* Required by the following drawtypes as they determine their visual
---  brightness from their internal light value:
---  * torchlike
---  * signlike
---  * firelike
---  * fencelike
---  * raillike
---  * nodebox
---  * mesh
---  * plantlike
---  * plantlike_rooted
---|"light"
---* `param1` will not be used by the engine and can be used to store
---  an arbitrary value
---|"none"

---The function of `param2` is determined by `paramtype2` in node definition.
---`param2` is reserved for the engine when `paramtype2 != "none"`.
---@alias mt.ParamType2
---* Used by `drawtype = "flowingliquid"` and `liquidtype = "flowing"`
---* The liquid level and a flag of the liquid are stored in `param2`
---* Bits 0-2: Liquid level (0-7). The higher, the more liquid is in this node;
---  see `minetest.get_node_level`, `minetest.set_node_level` and `minetest.add_node_level`
---  to access/manipulate the content of this field
---* Bit 3: If set, liquid is flowing downwards (no graphical effect)
---|"flowingliquid"
---* Supported drawtypes: "torchlike", "signlike", "plantlike",
---  "plantlike_rooted", "normal", "nodebox", "mesh"
---* The rotation of the node is stored in `param2`
---* Node is 'mounted'/facing towards one of 6 directions
---* You can make this value by using `minetest.dir_to_wallmounted()`
---* Values range 0 - 5
---* The value denotes at which direction the node is "mounted":
---  `0 = y+,   1 = y-,   2 = x+,   3 = x-,   4 = z+,   5 = z-`
---* By default, on placement the param2 is automatically set to the
---  appropriate rotation, depending on which side was pointed at
---|"wallmounted"
---* Supported drawtypes: "normal", "nodebox", "mesh"
---* The rotation of the node is stored in `param2`.
---* Node is rotated around face and axis; 24 rotations in total.
---* Can be made by using `minetest.dir_to_facedir()`.
---* Chests and furnaces can be rotated that way, and also 'flipped'
---* Values range 0 - 23
---* facedir / 4 = axis direction:
---  0 = y+,   1 = z+,   2 = z-,   3 = x+,   4 = x-,   5 = y-
---* The node is rotated 90 degrees around the X or Z axis so that its top face
---  points in the desired direction. For the y- direction, it's rotated 180
---  degrees around the Z axis.
---* facedir modulo 4 = left-handed rotation around the specified axis, in 90° steps.
---* By default, on placement the param2 is automatically set to the
---  horizontal direction the player was looking at (values 0-3)
---* Special case: If the node is a connected nodebox, the nodebox
---  will NOT rotate, only the textures will.
---|"facedir"
---* Supported drawtypes: "normal", "nodebox", "mesh"
---* The rotation of the node is stored in `param2`.
---* Allows node to be rotated horizontally, 4 rotations in total
---* Can be made by using `minetest.dir_to_fourdir()`.
---* Chests and furnaces can be rotated that way, but not flipped
---* Values range 0 - 3
---* 4dir modulo 4 = rotation
---* Otherwise, behavior is identical to facedir
---|"4dir"
---* Only valid for "nodebox" with 'type = "leveled"', and "plantlike_rooted".
---  * Leveled nodebox:
---    * The level of the top face of the nodebox is stored in `param2`.
---    * The other faces are defined by 'fixed = {}' like 'type = "fixed"'
---      nodeboxes.
---    * The nodebox height is (`param2` / 64) nodes.
---    * The maximum accepted value of `param2` is 127.
---  * Rooted plantlike:
---    * The height of the 'plantlike' section is stored in `param2`.
---    * The height is (`param2` / 16) nodes.
---|"leveled"
---* Valid for `plantlike` and `mesh` drawtypes. The rotation of the node is
---  stored in `param2`.
---* Values range 0–239. The value stored in `param2` is multiplied by 1.5 to
---  get the actual rotation in degrees of the node.
---|"degrotate"
---* Only valid for "plantlike" drawtype. `param2` encodes the shape and
---  optional modifiers of the "plant". `param2` is a bitfield.
---* Bits 0 to 2 select the shape. Use only one of the values below:
---  * 0 = an "x" shaped plant (ordinary plant)
---  * 1 = a "+" shaped plant (just rotated 45 degrees)
---  * 2 = a "*" shaped plant with 3 faces instead of 2
---  * 3 = a "#" shaped plant with 4 faces instead of 2
---  * 4 = a "#" shaped plant with 4 faces that lean outwards
---  * 5-7 are unused and reserved for future meshes.
---* Bits 3 to 7 are used to enable any number of optional modifiers.
---  Just add the corresponding value(s) below to `param2`:
---  * 8  - Makes the plant slightly vary placement horizontally
---  * 16 - Makes the plant mesh 1.4x larger
---  * 32 - Moves each face randomly a small bit down (1/8 max)
---  * values 64 and 128 (bits 6-7) are reserved for future use.
---* Example: `param2 = 0` selects a normal "x" shaped plant
---* Example: `param2 = 17` selects a "+" shaped plant, 1.4x larger (1+16)
---|"meshoptions"
---* `param2` tells which color is picked from the palette.
---  The palette should have 256 pixels.
---|"color"
---* Same as `facedir`, but with colors.
---* The first three bits of `param2` tells which color is picked from the
---  palette. The palette should have 8 pixels.
---|"colorfacedir"
---* Same as `facedir`, but with colors.
---* The first six bits of `param2` tells which color is picked from the
---  palette. The palette should have 64 pixels.
---|"color4dir"
---* Same as `wallmounted`, but with colors.
---* The first five bits of `param2` tells which color is picked from the
---  palette. The palette should have 32 pixels.
---|"colorwallmounted"
---* Only valid for "glasslike_framed" or "glasslike_framed_optional"
---  drawtypes. "glasslike_framed_optional" nodes are only affected if the
---  "Connected Glass" setting is enabled.
---* Bits 0-5 define 64 levels of internal liquid, 0 being empty and 63 being
---  full.
---* Bits 6 and 7 modify the appearance of the frame and node faces. One or
---  both of these values may be added to `param2`:
---  * 64  - Makes the node not connect with neighbors above or below it.
---  * 128 - Makes the node not connect with neighbors to its sides.
---* Liquid texture is defined using `special_tiles = {"modname_tilename.png"}`
---|"glasslikeliquidlevel"
---* Same as `degrotate`, but with colors.
---* The first (most-significant) three bits of `param2` tells which color
---  is picked from the palette. The palette should have 8 pixels.
---* Remaining 5 bits store rotation in range 0–23 (i.e. in 15° steps)
---|"colordegrotate"
---* `param2` will not be used by the engine and can be used to store
---  an arbitrary value
---|"none"

---Node drawtypes
-----------------

---There are a bunch of different looking node types.
---
---Look for examples in `games/devtest` or `games/minetest_game`.
---
---`*_optional` drawtypes need less rendering time if deactivated.
---(always client-side).
---@alias mt.DrawType string
---* A node-sized cube.
---|"normal"
---* Invisible, uses no texture.
---|"airlike"
---* The cubic source node for a liquid.
---* Faces bordering to the same node are never rendered.
---* Connects to node specified in `liquid_alternative_flowing`.
---* You *must* set `liquid_alternative_source` to the node's own name.
---* Use `backface_culling = false` for the tiles you want to make
---  visible when inside the node.
---|"liquid"
---* The flowing version of a liquid, appears with various heights and slopes.
---* Faces bordering to the same node are never rendered.
---* Connects to node specified in `liquid_alternative_source`.
---* You *must* set `liquid_alternative_flowing` to the node's own name.
---* Node textures are defined with `special_tiles` where the first tile
---  is for the top and bottom faces and the second tile is for the side
---  faces.
---* `tiles` is used for the item/inventory/wield image rendering.
---* Use `backface_culling = false` for the special tiles you want to make
---  visible when inside the node
---|"flowingliquid"
---* Often used for partially-transparent nodes.
---* Only external sides of textures are visible.
---|"glasslike"
---* All face-connected nodes are drawn as one volume within a surrounding
---  frame.
---* The frame appearance is generated from the edges of the first texture
---  specified in `tiles`. The width of the edges used are 1/16th of texture
---  size: 1 pixel for 16x16, 2 pixels for 32x32 etc.
---* The glass 'shine' (or other desired detail) on each node face is supplied
---  by the second texture specified in `tiles`.
---|"glasslike_framed"
---* This switches between the above 2 drawtypes according to the menu setting
---  'Connected Glass'.
---|"glasslike_framed_optional"
---* Often used for partially-transparent nodes.
---* External and internal sides of textures are visible.
---|"allfaces"
---* Often used for leaves nodes.
---* This switches between `normal`, `glasslike` and `allfaces` according to
---  the menu setting: Opaque Leaves / Simple Leaves / Fancy Leaves.
---* With 'Simple Leaves' selected, the texture specified in `special_tiles`
---  is used instead, if present. This allows a visually thicker texture to be
---  used to compensate for how `glasslike` reduces visual thickness.
---|"allfaces_optional"
---* A single vertical texture.
---* If `paramtype2="[color]wallmounted"`:
---  * If placed on top of a node, uses the first texture specified in `tiles`.
---  * If placed against the underside of a node, uses the second texture
---    specified in `tiles`.
---  * If placed on the side of a node, uses the third texture specified in
---    `tiles` and is perpendicular to that node.
---* If `paramtype2="none"`:
---  * Will be rendered as if placed on top of a node (see
---    above) and only the first texture is used.
---|"torchlike"
---* A single texture parallel to, and mounted against, the top, underside or
---  side of a node.
---* If `paramtype2="[color]wallmounted"`, it rotates according to `param2`
---* If `paramtype2="none"`, it will always be on the floor.
---|"signlike"
---* Two vertical and diagonal textures at right-angles to each other.
---* See `paramtype2 = "meshoptions"` above for other options.
---|"plantlike"
---* When above a flat surface, appears as 6 textures, the central 2 as
---  `plantlike` plus 4 more surrounding those.
---* If not above a surface the central 2 do not appear, but the texture
---  appears against the faces of surrounding nodes if they are present.
---|"firelike"
---* A 3D model suitable for a wooden fence.
---* One placed node appears as a single vertical post.
---* Adjacently-placed nodes cause horizontal bars to appear between them.
---|"fencelike"
---* Often used for tracks for mining carts.
---* Requires 4 textures to be specified in `tiles`, in order: Straight,
---  curved, t-junction, crossing.
---* Each placed node automatically switches to a suitable rotated texture
---  determined by the adjacent `raillike` nodes, in order to create a
---  continuous track network.
---* Becomes a sloping node if placed against stepped nodes.
---|"raillike"
---* Often used for stairs and slabs.
---* Allows defining nodes consisting of an arbitrary number of boxes.
---* See [Node boxes] below for more information.
---|"nodebox"
---* Uses models for nodes.
---* Tiles should hold model materials textures.
---* Only static meshes are implemented.
---* For supported model formats see Irrlicht engine documentation.
---|"mesh"
---* Enables underwater `plantlike` without air bubbles around the nodes.
---* Consists of a base cube at the co-ordinates of the node plus a
---  `plantlike` extension above
---* If `paramtype2="leveled", the `plantlike` extension has a height
---  of `param2 / 16` nodes, otherwise it's the height of 1 node
---* If `paramtype2="wallmounted"`, the `plantlike` extension
---  will be at one of the corresponding 6 sides of the base cube.
---  Also, the base cube rotates like a `normal` cube would
---* The `plantlike` extension visually passes through any nodes above the
---  base cube without affecting them.
---* The base cube texture tiles are defined as normal, the `plantlike`
---  extension uses the defined special tile, for example:
---  `special_tiles = {{name = "default_papyrus.png"}},`
---|"plantlike_rooted"

---Node boxes
-------------

---Node selection boxes are defined using "node boxes".
---
---A nodebox is defined as any of:
---
---    {
---        -- A normal cube; the default in most things
---        type = "regular"
---    }
---    {
---        -- A fixed box (or boxes) (facedir param2 is used, if applicable)
---        type = "fixed",
---        fixed = box OR {box1, box2, ...}
---    }
---    {
---        -- A variable height box (or boxes) with the top face position defined
---        -- by the node parameter 'leveled = ', or if 'paramtype2 == "leveled"'
---        -- by param2.
---        -- Other faces are defined by 'fixed = {}' as with 'type = "fixed"'.
---        type = "leveled",
---        fixed = box OR {box1, box2, ...}
---    }
---    {
---        -- A box like the selection box for torches
---        -- (wallmounted param2 is used, if applicable)
---        type = "wallmounted",
---        wall_top = box,
---        wall_bottom = box,
---        wall_side = box
---    }
---    {
---        -- A node that has optional boxes depending on neighboring nodes'
---        -- presence and type. See also `connects_to`.
---        type = "connected",
---        fixed = box OR {box1, box2, ...}
---        connect_top = box OR {box1, box2, ...}
---        connect_bottom = box OR {box1, box2, ...}
---        connect_front = box OR {box1, box2, ...}
---        connect_left = box OR {box1, box2, ...}
---        connect_back = box OR {box1, box2, ...}
---        connect_right = box OR {box1, box2, ...}
---        -- The following `disconnected_*` boxes are the opposites of the
---        -- `connect_*` ones above, i.e. when a node has no suitable neighbor
---        -- on the respective side, the corresponding disconnected box is drawn.
---        disconnected_top = box OR {box1, box2, ...}
---        disconnected_bottom = box OR {box1, box2, ...}
---        disconnected_front = box OR {box1, box2, ...}
---        disconnected_left = box OR {box1, box2, ...}
---        disconnected_back = box OR {box1, box2, ...}
---        disconnected_right = box OR {box1, box2, ...}
---        disconnected = box OR {box1, box2, ...} -- when there is *no* neighbor
---        disconnected_sides = box OR {box1, box2, ...} -- when there are *no*
---                                                      -- neighbors to the sides
---    }
---
---A `box` is defined as:
---
---    {x1, y1, z1, x2, y2, z2}
---
---A box of a regular node would look like:
---
---    {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
---
---To avoid collision issues, keep each value within the range of +/- 1.45.
---This also applies to leveled nodeboxes, where the final height shall not
---exceed this soft limit.
---@class mt.NodeBox
---@field type mt.ParamType2|"regular"|"fixed"|"connected"
---@field fixed mt.NodeBox|mt.NodeBox[]
---@field wall_top mt.NodeBox
---@field wall_bottom mt.NodeBox
---@field wall_side mt.NodeBox
---@field connect_top mt.NodeBox|mt.NodeBox[]
---@field connect_bottom mt.NodeBox|mt.NodeBox[]
---@field connect_front mt.NodeBox|mt.NodeBox[]
---@field connect_left mt.NodeBox|mt.NodeBox[]
---@field connect_back mt.NodeBox|mt.NodeBox[]
---@field connect_right mt.NodeBox|mt.NodeBox[]
---@field disconnect_top mt.NodeBox|mt.NodeBox[]
---@field disconnect_bottom mt.NodeBox|mt.NodeBox[]
---@field disconnect_front mt.NodeBox|mt.NodeBox[]
---@field disconnect_left mt.NodeBox|mt.NodeBox[]
---@field disconnect_back mt.NodeBox|mt.NodeBox[]
---@field disconnect_right mt.NodeBox|mt.NodeBox[]
---@field disconnected_sides mt.NodeBox|mt.NodeBox[]
---@field [1] number x1
---@field [2] number y1
---@field [3] number z1
---@field [4] number x2
---@field [5] number y2
---@field [6] number z2
local box = {}

---A 'mapblock' (often abbreviated to 'block') is 16x16x16 nodes and is the
---fundamental region of a world that is stored in the world database, sent to
---clients and handled by many parts of the engine.
---'mapblock' is preferred terminology to 'block' to help avoid confusion with
---'node', however 'block' often appears in the API.
---@alias mt.MapBlock table

---A 'mapchunk' (sometimes abbreviated to 'chunk') is usually 5x5x5 mapblocks
---(80x80x80 nodes) and is the volume of world generated in one operation by
---the map generator.
---The size in mapblocks has been chosen to optimize map generation.
---@alias mt.MapChunk table
