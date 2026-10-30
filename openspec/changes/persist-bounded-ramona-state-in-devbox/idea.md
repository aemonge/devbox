# Idea: Persist Bounded Agent Recovery State in Devbox

A normal writable devbox should preserve the narrowly named private state that
approved agent workflows use for recovery across sandbox exit. A green in-box
check is not durable evidence when its checkpoint disappears with the disposable
home layer.

Persistence must remain least-authority. Bind only explicitly supported state
namespaces, keep owner-only permissions, leave unrelated XDG state hidden, and
preserve locked mode as ephemeral. Each added namespace needs an exit-and-reenter
canary proving that bytes survive without broadening host state access.

This Idea may parent multiple independently validated Plans.
