// Turns published story versions and deity story cards into "decks" for
// storyteller mode. A deck only rearranges snapshot text; it never adds facts.

export const buildStoryIndex = (data) => {
  const sectionsById = new Map()
  const versionsById = new Map()
  const storiesById = new Map()
  for (const story of data?.stories || []) {
    storiesById.set(story.id, story)
    for (const version of story.versions) {
      versionsById.set(version.id, { story, version })
      for (const section of version.sections) sectionsById.set(section.id, { story, version, section })
    }
  }
  const claimsById = new Map((data?.claims || []).map((claim) => [claim.id, claim]))
  const cardsByEntity = new Map((data?.deityStoryCards || []).map((card) => [card.entityId, card]))
  return { sectionsById, versionsById, storiesById, claimsById, cardsByEntity }
}

const sourceLine = (title, location) => [title, location].filter(Boolean).join(' · ')

const sectionBeat = (story, version, section) => ({
  id: section.id,
  headingZh: section.headingZh,
  headingEn: section.headingEn,
  textZh: section.bodyZh,
  textEn: section.bodyEn,
  note: section.evidenceNote,
  uncertainty: section.uncertaintyNote,
  source: sourceLine(version.source?.title || version.sourceId, version.sourceLocation),
  claimId: section.anchorClaimId,
  storyId: story.id,
})

export const deckFromVersion = (story, version) => ({
  id: version.id,
  kind: 'STORY',
  titleZh: story.titleZh || story.canonicalTitle,
  titleEn: story.canonicalTitle,
  subtitleZh: version.labelZh,
  subtitleEn: version.labelEn,
  civilizationZh: story.civilizationNameZh || story.civilizationName,
  civilizationEn: story.civilizationName,
  accessLevel: version.accessLevel || story.accessLevel,
  storyId: story.id,
  beats: version.sections.map((section) => sectionBeat(story, version, section)),
  closingZh: story.editorialNote,
  closingEn: story.editorialNote,
})

const claimBeat = (beat, claim) => {
  const evidence = (claim?.evidence || []).find((item) => item.direction === 'SUPPORTS') || claim?.evidence?.[0]
  return {
    id: beat.claimId,
    headingZh: null,
    headingEn: null,
    textZh: beat.textZh,
    textEn: claim?.statement || '',
    note: null,
    layer: claim?.knowledgeLayer,
    scope: claim?.assertionScope,
    uncertainty: null,
    source: evidence ? sourceLine(evidence.sourceTitle, evidence.sourceLocation) : '',
    claimId: beat.claimId,
  }
}

export const deckFromCard = (card, index) => {
  const beats = card.beats.map((beat) => {
    if (beat.kind === 'STORY_SECTION') {
      const found = index.sectionsById.get(beat.sectionId)
      return found ? sectionBeat(found.story, found.version, found.section) : null
    }
    return claimBeat(beat, index.claimsById.get(beat.claimId))
  }).filter(Boolean)
  const primary = card.primaryStoryId ? index.storiesById.get(card.primaryStoryId) : null
  return {
    id: card.entityId,
    kind: 'DEITY',
    entityId: card.entityId,
    titleZh: card.nameZh,
    titleEn: card.name,
    subtitleZh: primary ? primary.titleZh : '证据卡',
    subtitleEn: primary ? primary.canonicalTitle : 'Evidence card',
    civilizationZh: card.civilizationNameZh || card.civilizationName,
    civilizationEn: card.civilizationName,
    accessLevel: card.accessLevel,
    storyId: card.primaryStoryId,
    hookZh: card.hookZh,
    hookEn: card.hookEn,
    beats,
    boundaryZh: card.boundary?.textZh,
    boundaryEn: card.boundary?.textEn,
  }
}
