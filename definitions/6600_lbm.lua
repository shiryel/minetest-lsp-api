---@meta

--- Used by `core.register_lbm`.
---
--- A loading block modifier (LBM) is used to define a function that is called for
--- specific nodes (defined by `nodenames`) when a mapblock which contains such nodes
--- gets activated (not loaded!).
---@class mt.LBMDef
--- Descriptive label for profiling purposes (optional).
--- Definitions with identical labels will be listed as one.
---@field label string|nil
---@field name string
--- * List of node names to trigger the LBM on.
--- * Also non-registered nodes will work.
--- * Groups (as of group:groupname) will work as well.
---@field nodenames string[]
--- Whether to run the LBM's action every time a block gets activated,
--- and not only the first time the block gets activated after the LBM
--- was introduced.
---@field run_at_every_load boolean
--- Function triggered for each qualifying node.
--- `dtime_s` is the in-game time (in seconds) elapsed since the block
--- was last active
---@field action fun(pos:mt.Vector, node:mt.Node, dtime_s: number)
