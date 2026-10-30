# Idea: Preserve conventional Unix interfaces in bounded devboxes

Bounded development environments should support the conventional Unix interfaces expected by standard shells and developer tools, so ordinary workflows behave consistently without requiring sandbox-specific workarounds.

Preserve least exposure: provide only the named pseudo-filesystem interfaces or compatibility endpoints required for normal behavior, use the sandbox runtime's safe mechanisms, and do not broaden host filesystem, device, credential, network, or configuration access. Each compatibility repair remains an independently validated Plan.

This Idea may parent multiple independently validated Plans.
