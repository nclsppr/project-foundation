# Web profile

Activate this profile for a website, web application, dashboard, or published documentation.

This profile implements `P08`, `P10`, `P13`, `P14`, and default `D06`. Its gates are activated at project level. The definition of done then activates only the gates that apply to the work unit.

## User contract

- Define the primary path and its result.
- Make loading, empty, error, success, and unavailable states explicit.
- Preserve existing public contracts: URLs, anchors, parameters, and deep links.
- Identify demonstration data.
- Preserve an essential function without optional enhancement when practical.

## Accessibility

- Prefer native HTML elements and controls. Use ARIA to supplement behavior that HTML cannot express.
- Provide complete keyboard navigation.
- Provide visible focus in a logical order.
- Meet at least WCAG AA contrast, unless a documented exception applies.
- Use touch targets of at least 44 px on a touch interface or coarse pointer.
- Synchronize ARIA state with the interface.
- Do not communicate meaning only with color.
- Give informative images useful alternatives.
- Hide decoration from assistive technologies.
- Manage focus in modal dialogs and make the background inert.
- Respect `prefers-reduced-motion`.
- Give each field a label and accessible name.
- Associate instructions and errors with their fields.
- Support zoom, text enlargement, and reflow without information loss.
- Provide captions or a transcript when media communicates information.

## Responsive layout

- Design the mobile composition. Do not only reduce the desktop version.
- Verify at least one small touch viewport and one desktop viewport.
- Test short content, long content, and strings that cannot wrap.
- Prevent unintended horizontal overflow.
- Use hover behavior only on devices that support it.

## Design system

- Write `DESIGN.md` before a significant redesign.
- A Full or Critical pack with this profile includes `DESIGN.md`. A Minimal or Standard pack keeps a lightweight intent in its brief or `PROJECT.md`, unless the scope requires the complete template.
- Define tokens and their executable source.
- Link each visual difference to a product intent.
- Avoid generic decoration without a function.
- Document frozen areas.
- Select images by function: information, narrative, identity, or atmosphere.

## Performance and resilience

- Define a reference device and network.
- Set budgets for images, JavaScript, rendering, and motion.
- Suspend off-screen or hidden-tab enhancements when applicable.
- A decorative or 3D layer must not modify the business domain.
- Provide fallback behavior if WebGL, JavaScript, or an optional dependency fails.

## SEO and publication

For a public surface:

- title, description, canonical metadata, and social metadata;
- `lang` and `hreflang` for multilingual content;
- consistent sitemap and robots configuration;
- explicit indexing state for experiments;
- artifact-specific cache busting;
- HTTP and visual verification of the published URL.

## Minimum gate

- project static controls and tests;
- no unexpected console or network error;
- mobile and desktop;
- keyboard and focus;
- normal and reduced motion;
- supported themes;
- routes and links;
- performance on the defined target;
- final URL after deployment.
