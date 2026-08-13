import { DISCUSSIONS_URL, REPOSITORY_URL, issueUrl } from '../config.js'
import { BookIcon, EditIcon, ExternalIcon, GithubIcon, NetworkIcon, PlusIcon } from './Icons.jsx'

const WAY_ICONS = [EditIcon, PlusIcon, BookIcon, NetworkIcon]

export default function ContributeView({ copy, language }) {
  return (
    <main className="single-view contribute-view">
      <section className="contribute-intro">
        <div>
          <h1>{copy.contributeTitle}</h1>
          <p>{copy.contributeIntro}</p>
        </div>
        <div className="contribute-primary-actions">
          <a href={issueUrl('data-correction.yml')} rel="noreferrer" target="_blank"><EditIcon size={20} />{copy.submitCorrection}<ExternalIcon size={15} /></a>
          <a href={issueUrl('new-entity.yml')} rel="noreferrer" target="_blank"><PlusIcon size={20} />{language === 'zh' ? '建议新实体' : 'Suggest an entity'}<ExternalIcon size={15} /></a>
        </div>
      </section>

      <section className="contribution-ways">
        {copy.contributionWays.map(([title, description], index) => {
          const IconComponent = WAY_ICONS[index]
          return (
            <article key={title}>
              <IconComponent size={28} />
              <h2>{title}</h2>
              <p>{description}</p>
            </article>
          )
        })}
      </section>

      <section className="contribution-principles">
        <h2>{language === 'zh' ? '贡献原则' : 'Contribution principles'}</h2>
        <ol>
          <li>{language === 'zh' ? '提供可追踪来源：原始文本、铭文、馆藏、官方遗址、学术出版物或活态传统授权语境。' : 'Provide traceable sources: primary texts, inscriptions, collections, official sites, scholarship, or authorized living-tradition context.'}</li>
          <li>{language === 'zh' ? '区分神话叙事、历史现实、考古证据、学术解释与现代改编。' : 'Separate mythic narrative, historical reality, archaeological evidence, scholarship, and modern adaptation.'}</li>
          <li>{language === 'zh' ? '不同版本可以并存；不要因为名称相似就自动合并。' : 'Variant accounts may coexist; do not merge entities by name similarity alone.'}</li>
          <li>{language === 'zh' ? '尊重活态传统的社区权限、限制知识和自我命名。' : 'Respect community permissions, restricted knowledge, and self-identification in living traditions.'}</li>
        </ol>
      </section>

      <section className="community-links">
        <a href={DISCUSSIONS_URL} rel="noreferrer" target="_blank"><NetworkIcon size={22} /><span><strong>{copy.openDiscussion}</strong><small>{language === 'zh' ? '提出问题、比较版本或分享研究方向' : 'Ask questions, compare variants, and share research directions'}</small></span><ExternalIcon size={17} /></a>
        <a href={REPOSITORY_URL} rel="noreferrer" target="_blank"><GithubIcon size={22} /><span><strong>{copy.viewRepository}</strong><small>{language === 'zh' ? '查看代码、数据库、来源登记和版本历史' : 'Inspect code, data, source registry, and release history'}</small></span><ExternalIcon size={17} /></a>
        <a href={`${REPOSITORY_URL}/blob/main/CONTRIBUTING.md`} rel="noreferrer" target="_blank"><BookIcon size={22} /><span><strong>{copy.contributionGuide}</strong><small>{language === 'zh' ? '中英文贡献流程与数据要求' : 'Bilingual workflow and data requirements'}</small></span><ExternalIcon size={17} /></a>
      </section>
    </main>
  )
}
