import { CompassMark, MenuIcon, CloseIcon } from './Icons.jsx'

const NAV_ITEMS = ['explore', 'stories', 'workbench', 'graph', 'thunder', 'evidence', 'progress', 'contribute']

export default function Header({ activeView, language, menuOpen, onNavigate, onToggleLanguage, onToggleMenu, copy }) {
  const chooseView = (view) => {
    onNavigate(view)
    if (menuOpen) onToggleMenu()
  }

  return (
    <header className="site-header">
      <button className="brand" type="button" onClick={() => chooseView('explore')}>
        <CompassMark className="brand-mark" size={48} />
        <span className="brand-copy">
          <strong>{copy.brand}</strong>
          <small>{copy.brandEnglish}</small>
        </span>
      </button>

      <nav aria-label="Primary navigation" className={`primary-nav ${menuOpen ? 'is-open' : ''}`}>
        {NAV_ITEMS.map((item) => (
          <button
            className={activeView === item ? 'is-active' : ''}
            key={item}
            type="button"
            onClick={() => chooseView(item)}
          >
            {copy.nav[item]}
          </button>
        ))}
      </nav>

      <div className="header-actions">
        <button
          aria-label={copy.languageLabel}
          className="language-switch"
          type="button"
          onClick={onToggleLanguage}
        >
          <span className={language === 'zh' ? 'is-active' : ''}>中</span>
          <i>/</i>
          <span className={language === 'en' ? 'is-active' : ''}>EN</span>
        </button>
        <button
          aria-expanded={menuOpen}
          aria-label={menuOpen ? copy.close : copy.menu}
          className="menu-button"
          type="button"
          onClick={onToggleMenu}
        >
          {menuOpen ? <CloseIcon size={26} /> : <MenuIcon size={28} />}
        </button>
      </div>
    </header>
  )
}
