import AsyncStorage from '@react-native-async-storage/async-storage';

const KEY = '@nexusnews_bookmarks';

export const getBookmarks = async () => {
  const stored = await AsyncStorage.getItem(KEY);
  return stored ? JSON.parse(stored) : [];
};

export const addBookmark = async (article) => {
  const current = await getBookmarks();
  if (current.some((a) => a.id === article.id)) return;
  const updated = [article, ...current];
  await AsyncStorage.setItem(KEY, JSON.stringify(updated));
};

export const removeBookmark = async (articleId) => {
  const current = await getBookmarks();
  const updated = current.filter((a) => a.id !== articleId);
  await AsyncStorage.setItem(KEY, JSON.stringify(updated));
};

export const isBookmarked = async (articleId) => {
  const current = await getBookmarks();
  return current.some((a) => a.id === articleId);
};
