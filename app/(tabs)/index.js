import React, { useState, useEffect, useCallback } from 'react';
import {
  View,
  FlatList,
  ScrollView,
  Text,
  TouchableOpacity,
  ActivityIndicator,
  RefreshControl,
  StyleSheet,
} from 'react-native';
import { useTheme } from '../../context/ThemeContext';
import { fetchTopHeadlines, fetchByCategory, CATEGORIES } from '../../services/newsApi';
import { addBookmark, removeBookmark, isBookmarked } from '../../services/bookmarks';
import ArticleCard from '../../components/ArticleCard';

export default function FeedScreen() {
  const { colors } = useTheme();
  const [category, setCategory] = useState('general');
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [bookmarkedIds, setBookmarkedIds] = useState(new Set());

  const fetchNews = useCallback(async (cat) => {
    const result = cat === 'general'
      ? await fetchTopHeadlines()
      : await fetchByCategory(cat);
    setArticles(result.articles);
  }, []);

  useEffect(() => {
    setLoading(true);
    fetchNews(category).finally(() => setLoading(false));
  }, [category]);

  const onRefresh = useCallback(async () => {
    setRefreshing(true);
    await fetchNews(category);
    setRefreshing(false);
  }, [category, fetchNews]);

  const handleBookmark = async (article) => {
    const already = bookmarkedIds.has(article.id);
    const next = new Set(bookmarkedIds);
    if (already) {
      await removeBookmark(article.id);
      next.delete(article.id);
    } else {
      await addBookmark(article);
      next.add(article.id);
    }
    setBookmarkedIds(next);
  };

  const styles = makeStyles(colors);

  return (
    <View style={styles.container}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.chips}
      >
        {CATEGORIES.map((cat) => (
          <TouchableOpacity
            key={cat}
            style={[styles.chip, cat === category && styles.chipActive]}
            onPress={() => setCategory(cat)}
          >
            <Text style={[styles.chipText, cat === category && styles.chipTextActive]}>
              {cat.charAt(0).toUpperCase() + cat.slice(1)}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {loading ? (
        <ActivityIndicator style={styles.loader} color={colors.accent} size="large" />
      ) : (
        <FlatList
          data={articles}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <ArticleCard
              article={item}
              bookmarked={bookmarkedIds.has(item.id)}
              onBookmarkToggle={handleBookmark}
            />
          )}
          contentContainerStyle={styles.list}
          refreshControl={
            <RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={colors.accent} />
          }
          ListEmptyComponent={
            <Text style={styles.emptyText}>No articles found.</Text>
          }
        />
      )}
    </View>
  );
}

function makeStyles(colors) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    chips: {
      paddingHorizontal: 16,
      paddingVertical: 12,
      flexDirection: 'row',
    },
    chip: {
      paddingHorizontal: 16,
      paddingVertical: 6,
      borderRadius: 20,
      backgroundColor: colors.chipBg,
      borderWidth: StyleSheet.hairlineWidth,
      borderColor: colors.chipBorder,
      marginRight: 8,
    },
    chipActive: {
      backgroundColor: colors.accent,
      borderColor: colors.accent,
    },
    chipText: {
      fontSize: 13,
      fontWeight: '600',
      color: colors.textSecondary,
    },
    chipTextActive: {
      color: '#FFFFFF',
    },
    loader: { marginTop: 60 },
    list: { paddingTop: 4, paddingBottom: 24 },
    emptyText: {
      textAlign: 'center',
      color: colors.textSecondary,
      marginTop: 60,
      fontSize: 15,
    },
  });
}
