export const graphLayout = (compact, kind) => {
  if (kind === 'mobile') {
    return compact
      ? {
          kind,
          width: 390,
          height: 360,
          centerX: 195,
          centerY: 165,
          radiusX: 135,
          radiusY: 105,
          centerRadius: 44,
          targetRadius: 22,
          orbitInner: 80,
          orbitOuter: 132,
        }
      : {
          kind,
          width: 390,
          height: 500,
          centerX: 195,
          centerY: 220,
          radiusX: 135,
          radiusY: 150,
          centerRadius: 48,
          targetRadius: 24,
          orbitInner: 98,
          orbitOuter: 148,
        }
  }

  return {
    kind,
    width: 760,
    height: compact ? 390 : 520,
    centerX: 380,
    centerY: compact ? 195 : 260,
    radiusX: compact ? 245 : 270,
    radiusY: compact ? 125 : 160,
    centerRadius: compact ? 49 : 60,
    targetRadius: compact ? 28 : 34,
    orbitInner: compact ? 104 : 136,
    orbitOuter: compact ? 160 : 214,
  }
}

export const nodePosition = (index, count, layout) => {
  const angle = (index / count) * Math.PI * 2 - Math.PI / 2
  return {
    x: layout.centerX + Math.cos(angle) * layout.radiusX,
    y: layout.centerY + Math.sin(angle) * layout.radiusY,
  }
}

export const mobileTextPlacement = (x, layout) => {
  if (layout.kind !== 'mobile') return { textAnchor: 'middle', textX: 0 }
  if (x < layout.width * 0.27) {
    return { textAnchor: 'start', textX: -layout.targetRadius - 3 }
  }
  if (x > layout.width * 0.73) {
    return { textAnchor: 'end', textX: layout.targetRadius + 3 }
  }
  return { textAnchor: 'middle', textX: 0 }
}
