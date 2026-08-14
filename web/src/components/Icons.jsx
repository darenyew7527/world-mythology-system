const Icon = ({ children, size = 22, className = '', viewBox = '0 0 24 24', ...props }) => (
  <svg
    aria-hidden="true"
    className={`icon ${className}`}
    fill="none"
    height={size}
    viewBox={viewBox}
    width={size}
    xmlns="http://www.w3.org/2000/svg"
    {...props}
  >
    {children}
  </svg>
)

const stroke = {
  stroke: 'currentColor',
  strokeLinecap: 'round',
  strokeLinejoin: 'round',
  strokeWidth: 1.6,
}

export const SearchIcon = (props) => (
  <Icon {...props}><circle cx="10.5" cy="10.5" r="6.5" {...stroke} /><path d="m15.5 15.5 5 5" {...stroke} /></Icon>
)

export const MenuIcon = (props) => (
  <Icon {...props}><path d="M4 6h16M4 12h16M4 18h16" {...stroke} /></Icon>
)

export const CloseIcon = (props) => (
  <Icon {...props}><path d="m5 5 14 14M19 5 5 19" {...stroke} /></Icon>
)

export const FilterIcon = (props) => (
  <Icon {...props}><path d="M4 5h16l-6.2 7.2V19l-3.6 1v-7.8L4 5Z" {...stroke} /></Icon>
)

export const ExternalIcon = (props) => (
  <Icon {...props}><path d="M14 5h5v5M12 12l7-7M19 13v6H5V5h6" {...stroke} /></Icon>
)

export const EditIcon = (props) => (
  <Icon {...props}><path d="m4 20 4.2-1 10.7-10.7-3.2-3.2L5 15.8 4 20Z" {...stroke} /><path d="m13.8 7 3.2 3.2" {...stroke} /></Icon>
)

export const PlusIcon = (props) => (
  <Icon {...props}><circle cx="12" cy="12" r="9" {...stroke} /><path d="M12 8v8M8 12h8" {...stroke} /></Icon>
)

export const CopyIcon = (props) => (
  <Icon {...props}><rect x="8" y="8" width="11" height="11" rx="1" {...stroke} /><path d="M16 8V5H5v11h3" {...stroke} /></Icon>
)

export const ChevronIcon = ({ direction = 'right', ...props }) => {
  const transforms = { right: 0, down: 90, left: 180, up: 270 }
  return <Icon style={{ transform: `rotate(${transforms[direction]}deg)` }} {...props}><path d="m9 5 7 7-7 7" {...stroke} /></Icon>
}

export const BookIcon = (props) => (
  <Icon {...props}><path d="M4 5.5A3.5 3.5 0 0 1 7.5 2H11v17H7.5A3.5 3.5 0 0 0 4 22V5.5ZM20 5.5A3.5 3.5 0 0 0 16.5 2H13v17h3.5A3.5 3.5 0 0 1 20 22V5.5Z" {...stroke} /></Icon>
)

export const NetworkIcon = (props) => (
  <Icon {...props}><circle cx="5" cy="12" r="2.2" {...stroke} /><circle cx="18.5" cy="5" r="2.2" {...stroke} /><circle cx="18.5" cy="19" r="2.2" {...stroke} /><path d="m7 11 9.4-4.9M7 13l9.4 4.9" {...stroke} /></Icon>
)

export const GlobeIcon = (props) => (
  <Icon {...props}><circle cx="12" cy="12" r="9" {...stroke} /><path d="M3.5 12h17M12 3c2.6 2.4 4 5.4 4 9s-1.4 6.6-4 9c-2.6-2.4-4-5.4-4-9s1.4-6.6 4-9Z" {...stroke} /></Icon>
)

export const DatabaseIcon = (props) => (
  <Icon {...props}><ellipse cx="12" cy="5" rx="7.5" ry="3" {...stroke} /><path d="M4.5 5v7c0 1.7 3.4 3 7.5 3s7.5-1.3 7.5-3V5M4.5 12v7c0 1.7 3.4 3 7.5 3s7.5-1.3 7.5-3v-7" {...stroke} /></Icon>
)

export const ThunderIcon = (props) => (
  <Icon {...props}>
    <path d="M13.7 2.8 6.8 13h5l-1.4 8.2L17.8 10h-5.2l1.1-7.2Z" {...stroke} />
    <path d="M4 7.5h3M17.3 17H20" {...stroke} opacity=".65" />
  </Icon>
)

export const AlertIcon = (props) => (
  <Icon {...props}><path d="M12 3 2.8 20h18.4L12 3Z" {...stroke} /><path d="M12 9v5M12 17.5h.01" {...stroke} /></Icon>
)

export const GithubIcon = (props) => (
  <Icon {...props}><path d="M12 2.8a9.2 9.2 0 0 0-2.9 17.9v-2.3c-2.4.5-2.9-1-2.9-1-.4-1.1-1-1.4-1-1.4-.8-.6.1-.6.1-.6.9.1 1.4.9 1.4.9.8 1.4 2.1 1 2.6.8.1-.6.3-1 .6-1.2-1.9-.2-4-1-4-4.1 0-1 .3-1.8.9-2.5-.1-.2-.4-1.2.1-2.5 0 0 .8-.3 2.5.9a8.5 8.5 0 0 1 4.6 0c1.8-1.2 2.5-.9 2.5-.9.5 1.3.2 2.3.1 2.5.6.7.9 1.5.9 2.5 0 3.2-2 3.9-4 4.1.3.3.6.8.6 1.6v3a9.2 9.2 0 0 0-3-17.9Z" {...stroke} /></Icon>
)

export const CompassMark = ({ size = 50, ...props }) => (
  <Icon size={size} viewBox="0 0 64 64" {...props}>
    <circle cx="32" cy="32" r="25" {...stroke} />
    <circle cx="32" cy="32" r="18" stroke="currentColor" strokeDasharray="1 5" strokeWidth="1" />
    <path d="M32 4v10M32 50v10M4 32h10M50 32h10" {...stroke} />
    <path d="m39 25-5 9-9 5 5-9 9-5Z" fill="currentColor" opacity=".92" />
    <path d="m32 14 2 14 14 4-14 4-2 14-2-14-14-4 14-4 2-14Z" {...stroke} />
  </Icon>
)

export const EntityGlyph = ({ type, size = 34 }) => {
  if (type === 'TEXT') return <BookIcon size={size} />
  if (['ARCHAEOLOGICAL_SITE', 'TEMPLE', 'MONUMENT', 'MYTHICAL_PLACE', 'REALM'].includes(type)) {
    return <Icon size={size}><path d="M3 20h18M5 17h14M7 9v8M12 9v8M17 9v8M4 7h16L12 3 4 7Z" {...stroke} /></Icon>
  }
  if (['WEAPON', 'ARTIFACT', 'SACRED_OBJECT', 'RING', 'SHIP'].includes(type)) {
    return <Icon size={size}><path d="m5 19 7-7M9 5l10 10M14 4l6 6M4 14l6 6" {...stroke} /></Icon>
  }
  if (['MONSTER', 'CREATURE', 'DIVINE_BEAST', 'GIANT', 'DWARF'].includes(type)) {
    return <Icon size={size}><path d="M5 17c1.5-5 4.5-8 9-9 1.5-.3 3.5.2 5 1-1 0-2 .5-2.5 1.5 2 .5 3.2 2 3.5 4-2-1-4-1-5 .5-1.5 2-3.5 3.5-6 4-1.5.2-3-.5-4-2Z" {...stroke} /><path d="M9 11 6 7M14 8l1-4" {...stroke} /></Icon>
  }
  if (['ELEMENT', 'POWER', 'CONCEPT'].includes(type)) {
    return <Icon size={size}><circle cx="12" cy="12" r="3" {...stroke} /><path d="M12 2v5M12 17v5M2 12h5M17 12h5M5 5l3.5 3.5M15.5 15.5 19 19M19 5l-3.5 3.5M8.5 15.5 5 19" {...stroke} /></Icon>
  }
  return <Icon size={size}><path d="M4 20h16M6 18h12M7 9v9M12 9v9M17 9v9M5 7h14l-7-4-7 4Z" {...stroke} /></Icon>
}
