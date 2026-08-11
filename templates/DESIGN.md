# DESIGN.md

Visual and user experience contract for the project. `AGENTS.md` has priority for work rules.

## Intent

### Target impression

TODO

### Product-specific differentiation

TODO Explain how the visual language supports attention, comprehension, trust, or conversion.

### Anti-goals

- TODO

## Principles

1. TODO

## Tokens

The executable source for the tokens is: TODO.

### Colors

| Role | Token | Light | Dark | Required contrast |
| --- | --- | --- | --- | --- |
| TODO | TODO | TODO | TODO | TODO |

### Typography

| Role | Font | Measure | Use |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

### Spacing, radii, and shadows

TODO

## Layout

- Reading width: TODO
- Desktop grid: TODO
- Mobile composition: TODO
- Content-based breakpoints: TODO
- Permitted overflow: TODO

## Components

| Component | Use | Variants | Required states |
| --- | --- | --- | --- |
| TODO | TODO | TODO | default, hover, focus, active, disabled, loading, error |

## Interaction and motion

- Useful feedback: TODO
- Limited surfaces that can use decorative motion: TODO
- Maximum UI duration: TODO
- Animated properties: TODO
- Behavior with `prefers-reduced-motion`: TODO
- Hovers limited to compatible pointers: TODO

## Accessibility

- Target level: WCAG AA
- Contrast: TODO
- Focus: TODO
- Keyboard navigation: TODO
- Touch targets: TODO
- Dynamic ARIA: TODO
- Text alternatives: TODO
- States not communicated only by color: TODO

## Images and media

| Family | Function | Style | Format | Provenance |
| --- | --- | --- | --- | --- |
| TODO | information or narrative | TODO | TODO | TODO |

Rules:

- Keep functional text in the document, not in a generated image.
- Define dimensions, file size, transparency, and variants.
- Use a canonical source or prompt to prevent visual drift.
- Link each generated image to its use and provenance.

## Performance

- Image budget: TODO
- JavaScript budget: TODO
- Rendering or animation budget: TODO
- Reference device and network: TODO
- Fallback without enhancement: TODO

## Frozen areas

Items that do not change without an explicit decision:

- TODO

## Verification matrix

| Dimension | Values |
| --- | --- |
| Viewports | TODO mobile, desktop |
| Themes | TODO |
| Inputs | keyboard, touch, mouse |
| Motion | normal, reduced |
| Content | short, long, empty, error |
| Browsers | TODO |
| Required physical devices | TODO |
