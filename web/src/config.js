export const REPOSITORY_URL = 'https://github.com/darenyew7527/world-mythology-system'
export const DISCUSSIONS_URL = `${REPOSITORY_URL}/discussions`

export const issueUrl = (template, title = '') => {
  const parameters = new URLSearchParams({ template })
  if (title) parameters.set('title', title)
  return `${REPOSITORY_URL}/issues/new?${parameters.toString()}`
}
