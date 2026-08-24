const fetch = (...args) => import('node-fetch').then(m => m.default(...args));

const engines = {
  wikipedia: (q) => `https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(q)}&srlimit=1&sroffset=0&format=json&origin=*`,
  arxiv: (q) => `https://export.arxiv.org/api/query?search_query=all:${encodeURIComponent(q)}&start=0&max_results=1`,
  github: (q) => `https://api.github.com/search/repositories?q=${encodeURIComponent(q)}&per_page=1`,
  githubissues: (q) => `https://api.github.com/search/issues?q=${encodeURIComponent(q)}+in:issue&per_page=1`,
  stackoverflow: (q) => `https://api.stackexchange.com/2.3/search/advanced?q=${encodeURIComponent(q)}&site=stackoverflow&limit=1`,
  crossref: (q) => `https://api.crossref.org/works?query=${encodeURIComponent(q)}&rows=1`,
  pubmed: (q) => `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=${encodeURIComponent(q)}&retmax=1&retstart=0&retmode=json`,
  openlibrary: (q) => `https://openlibrary.org/search.json?q=${encodeURIComponent(q)}&limit=1`,
  wikibooks: (q) => `https://en.wikibooks.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(q)}&srlimit=1&format=json&origin=*`,
  internetarchive: (q) => `https://archive.org/advancedsearch.php?q=${encodeURIComponent(q)}&fl[]=title&rows=1&start=0&output=json`,
  wikidata: (q) => `https://www.wikidata.org/w/api.php?action=query&list=search&srsearch=${encodeURIComponent(q)}&srnamespace=120&srlimit=1&format=json&origin=*`,
  clinicaltrials: (q) => `https://clinicaltrials.gov/api/v2/studies?query.term=${encodeURIComponent(q)}&pageSize=1&pageOffset=0&format=json`,
  europepmc: (q) => `https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=${encodeURIComponent(q)}&format=json&resultType=core&pageSize=1&offset=0`,
  gitlab: (q) => `https://gitlab.com/api/v4/projects?search=${encodeURIComponent(q)}&per_page=1`,
  hackernews: (q) => `https://hn.algolia.com/api/v1/search?query=${encodeURIComponent(q)}&tags=story&page=0&hitsPerPage=1`,
  openalex: (q) => `https://api.openalex.org/works?search=${encodeURIComponent(q)}&per_page=1`,
  doaj: (q) => `https://doaj.org/api/search/articles/v2?q=${encodeURIComponent(q)}&pageSize=1&page=1`,
  dblp: (q) => `https://dblp.org/search/publ/api?q=${encodeURIComponent(q)}&h=1&format=json`,
  pubmedcentral: (q) => `https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pmc&term=${encodeURIComponent(q)}&retmax=1&retstart=0&retmode=json`,
  coingecko: (q) => `https://api.coingecko.com/api/v3/search?query=${encodeURIComponent(q)}`,
  tvmaze: (q) => `https://api.tvmaze.com/search/shows?q=${encodeURIComponent(q)}`,
  themealdb: (q) => `https://www.themealdb.com/api/json/v1/1/search.php?s=${encodeURIComponent(q)}`,
  dictionary: (q) => `https://api.dictionaryapi.dev/api/v2/entries/en/${encodeURIComponent(q)}`,
  pokeapi: () => `https://pokeapi.co/api/v2/pokemon?offset=0&limit=10`,
  jokeapi: () => `https://v2.jokeapi.dev/joke/Programming?amount=1`,
  swapi: (q) => `https://swapi.dev/api/people/?search=${encodeURIComponent(q)}`,
  openmeteo: (q) => `https://photon.komoot.de/api/?q=${encodeURIComponent(q)}`,
  semanticscholar: (q) => `https://api.semanticscholar.org/graph/v1/paper/search?query=${encodeURIComponent(q)}&limit=1&fields=title`,
};

async function test(name, url) {
  try {
    const start = Date.now();
    const r = await fetch(url, { signal: AbortSignal.timeout(8000) });
    const text = await r.text();
    const ms = Date.now() - start;
    if (r.ok) {
      let data;
      try { data = JSON.parse(text); } catch { data = text.slice(0, 50); }
      const ok = data && Object.keys(data).length > 0;
      console.log(`${ok ? '✅' : '⚠️'} ${name} [${ms}ms] status=${r.status} keys=${JSON.stringify(Object.keys(data)).slice(0,80)}`);
    } else {
      console.log(`❌ ${name} [${ms}ms] HTTP ${r.status}: ${text.slice(0, 80)}`);
    }
  } catch(e) {
    console.log(`❌ ${name} ERROR: ${e.message.slice(0, 80)}`);
  }
}

(async () => {
  const queries = {
    wikipedia: 'quantum computing', arxiv: 'quantum computing', github: 'react',
    githubissues: 'react', stackoverflow: 'react', crossref: 'quantum computing',
    pubmed: 'cancer treatment', openlibrary: 'react', wikibooks: 'mathematics',
    internetarchive: 'react', wikidata: 'quantum computing', clinicaltrials: 'cancer',
    europepmc: 'cancer', gitlab: 'react', hackernews: 'react', openalex: 'quantum computing',
    doaj: 'quantum computing', dblp: 'machine learning', pubmedcentral: 'cancer',
    coingecko: 'bitcoin', tvmaze: 'breaking bad', themealdb: 'chicken',
    dictionary: 'hello', pokeapi: 'pikachu', jokeapi: null, swapi: 'skywalker',
    openmeteo: 'beijing', semanticscholar: 'quantum computing',
  };
  for (const [name, query] of Object.entries(engines)) {
    const url = query(queries[name] || name);
    await test(name, url);
  }
})();
