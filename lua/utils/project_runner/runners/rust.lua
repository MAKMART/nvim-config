local M = {}

function M.build(build_type)
  -- optional: allow "release" builds
  build_type = build_type or "release"
  return build_type == "release" and "cargo build --release" or "cargo check"
end

function M.run(build_type)
  build_type = build_type or "release"
  return build_type == "release" and "cargo run --release" or "cargo run"
end

return M
