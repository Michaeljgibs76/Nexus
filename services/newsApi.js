const API_KEY = 'your_api_key_here';
const BASE_URL = 'https://newsapi.org/v2';

export const CATEGORIES = [
  'general',
  'technology',
  'business',
  'sports',
  'entertainment',
  'health',
  'science',
];

export const fetchTopHeadlines = async (page = 1, pageSize = 20) => {
  try {
    const res = await fetch(
      `${BASE_URL}/top-headlines?country=us&page=${page}&pageSize=${pageSize}&apiKey=${API_KEY}`
    );
    const data = await res.json();

    if (data.status !== 'ok') {
      throw new Error(data.message || 'API error');
    }

    return {
      articles: data.articles.map(normalizeArticle),
      totalResults: data.totalResults,
    };
  } catch (err) {
    console.error('Headlines fetch failed:', err);
    return { articles: [], totalResults: 0 };
  }
};

export const searchArticles = async (query, page = 1, pageSize = 20) => {
  try {
    const res = await fetch(
      `${BASE_URL}/everything?q=${encodeURIComponent(query)}&page=${page}&pageSize=${pageSize}&sortBy=publishedAt&apiKey=${API_KEY}`
    );
    const data = await res.json();

    if (data.status !== 'ok') {
      throw new Error(data.message || 'API error');
    }

    return {
      articles: data.articles.map(normalizeArticle),
      totalResults: data.totalResults,
    };
  } catch (err) {
    console.error('Search fetch failed:', err);
    return { articles: [], totalResults: 0 };
  }
};

export const fetchByCategory = async (category, page = 1, pageSize = 20) => {
  try {
    const res = await fetch(
      `${BASE_URL}/top-headlines?country=us&category=${category}&page=${page}&pageSize=${pageSize}&apiKey=${API_KEY}`
    );
    const data = await res.json();

    if (data.status !== 'ok') {
      throw new Error(data.message || 'API error');
    }

    return {
      articles: data.articles.map(normalizeArticle),
      totalResults: data.totalResults,
    };
  } catch (err) {
    console.error('Category fetch failed:', err);
    return { articles: [], totalResults: 0 };
  }
};

const normalizeArticle = (raw, index) => ({
  id: raw.url || index.toString(),
  title: raw.title || 'Untitled',
  author: raw.author,
  source: raw.source?.name || 'Unknown',
  publishedAt: formatDate(raw.publishedAt),
  timeAgo: getTimeAgo(raw.publishedAt),
  imageUrl: raw.urlToImage,
  body: raw.content || raw.description || '',
  description: raw.description || '',
  url: raw.url,
});

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    month: 'long',
    day: 'numeric',
    year: 'numeric',
  });
};

const getTimeAgo = (dateStr) => {
  if (!dateStr) return '';
  const now = new Date();
  const then = new Date(dateStr);
  const mins = Math.floor((now - then) / 60000);

  if (mins < 1) return 'Just now';
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  const days = Math.floor(hrs / 24);
  if (days < 7) return `${days}d ago`;
  return formatDate(dateStr);
};
