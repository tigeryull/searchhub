#!/bin/bash
queries=(
  "wikipedia:quantum computing"
  "arxiv:quantum computing"
  "github:react"
  "githubissues:react"
  "stackoverflow:react"
  "crossref:quantum computing"
  "pubmed:cancer treatment"
  "openlibrary:react"
  "wikibooks:mathematics"
  "internetarchive:react"
  "wikidata:quantum computing"
  "clinicaltrials:cancer"
  "europepmc:cancer"
  "gitlab:react"
  "hackernews:react"
  "openalex:quantum computing"
  "doaj:quantum computing"
  "dblp:machine learning"
  "pubmedcentral:cancer"
  "coingecko:bitcoin"
  "tvmaze:breaking bad"
  "themealdb:chicken"
  "dictionary:hello"
  "pokeapi:pikachu"
  "jokeapi:programming"
  "swapi:skywalker"
  "openmeteo:beijing"
  "semanticscholar:quantum computing"
)

for item in "${queries[@]}"; do
  name="${item%%:*}"
  query="${item##*:}"
  url=""
  case "$name" in
    wikipedia) url="https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&srlimit=1&sroffset=0&format=json&origin=*" ;;
    arxiv) url="https://export.arxiv.org/api/query?search_query=all:$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&start=0&max_results=1" ;;
    github) url="https://api.github.com/search/repositories?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&per_page=1" ;;
    githubissues) url="https://api.github.com/search/issues?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query + in:issue'))")&per_page=1" ;;
    stackoverflow) url="https://api.stackexchange.com/2.3/search/advanced?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&site=stackoverflow&limit=1" ;;
    crossref) url="https://api.crossref.org/works?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&rows=1" ;;
    pubmed) url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&retmax=1&retstart=0&retmode=json" ;;
    openlibrary) url="https://openlibrary.org/search.json?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&limit=1" ;;
    wikibooks) url="https://en.wikibooks.org/w/api.php?action=query&list=search&srsearch=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&srlimit=1&format=json&origin=*" ;;
    internetarchive) url="https://archive.org/advancedsearch.php?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&fl[]=title&rows=1&start=0&output=json" ;;
    wikidata) url="https://www.wikidata.org/w/api.php?action=query&list=search&srsearch=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&srnamespace=120&srlimit=1&format=json&origin=*" ;;
    clinicaltrials) url="https://clinicaltrials.gov/api/v2/studies?query.term=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&pageSize=1&pageOffset=0&format=json" ;;
    europepmc) url="https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&format=json&resultType=core&pageSize=1&offset=0" ;;
    gitlab) url="https://gitlab.com/api/v4/projects?search=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&per_page=1" ;;
    hackernews) url="https://hn.algolia.com/api/v1/search?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&tags=story&page=0&hitsPerPage=1" ;;
    openalex) url="https://api.openalex.org/works?search=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&per_page=1" ;;
    doaj) url="https://doaj.org/api/search/articles/v2?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&pageSize=1&page=1" ;;
    dblp) url="https://dblp.org/search/publ/api?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&h=1&format=json" ;;
    pubmedcentral) url="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pmc&term=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&retmax=1&retstart=0&retmode=json" ;;
    coingecko) url="https://api.coingecko.com/api/v3/search?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" ;;
    tvmaze) url="https://api.tvmaze.com/search/shows?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" ;;
    themealdb) url="https://www.themealdb.com/api/json/v1/1/search.php?s=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" ;;
    dictionary) url="https://api.dictionaryapi.dev/api/v2/entries/en/$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" ;;
    pokeapi) url="https://pokeapi.co/api/v2/pokemon?offset=0&limit=10" ;;
    jokeapi) url="https://v2.jokeapi.dev/joke/Programming?amount=1" ;;
    swapi) url="https://swapi.dev/api/people/?search=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" ;;
    openmeteo) url="https://photon.komoot.de/api/?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" ;;
    semanticscholar) url="https://api.semanticscholar.org/graph/v1/paper/search?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&limit=1&fields=title" ;;
  esac
  
  start=$(date +%s%3N)
  resp=$(curl -s -w "\n%{http_code}" --max-time 8 "$url" 2>/dev/null)
  ms=$(($(date +%s%3N) - start))
  http_code=$(echo "$resp" | tail -1)
  body=$(echo "$resp" | sed '$d')
  
  if [ "$http_code" = "200" ] && [ -n "$body" ]; then
    # Check if valid JSON with content
    is_valid=$(echo "$body" | python3 -c "import sys,json; d=json.load(sys.stdin); print('ok' if d and len(str(d))>0 else 'empty')" 2>/dev/null)
    if [ "$is_valid" = "ok" ]; then
      echo "✅ ${name} [${ms}ms] HTTP $http_code"
    else
      echo "⚠️  ${name} [${ms}ms] HTTP $http_code but empty response"
    fi
  else
    echo "❌ ${name} [${ms}ms] HTTP ${http_code:-ERROR}: $(echo "$body" | head -c 80)"
  fi
done
