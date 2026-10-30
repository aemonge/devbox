# Idea: Keep bounded development environments resource-complete

Developer boxes should preserve the globally installed, read-only resources that make the normal host workflow useful, so any project can use the same approved agents, delivery flows, and workflow schemas without per-session mount workarounds.

The direction is broader than one launcher repair but keeps a strict boundary: expose only named resource trees through existing safe bind mechanisms, retain project-local precedence, preserve fail-closed mount conflict handling, and never turn global configuration or workflow data into writable sandbox state.

This Idea may parent multiple independently validated Plans.
