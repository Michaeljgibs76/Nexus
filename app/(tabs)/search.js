import React, { useState, useCallback } from 'react';
import {
  View,
  TextInput,
  FlatList,
  Text,
  ActivityIndicator,
  TouchableOpacity,
  StyleSheet,
  Keyboard,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';
import { searchArticles } from '../../services/newsApi';
import { addBookmark, removeBookmark } from '../../services/bookmarks';
import ArticleCard from '../../components/ArticleCard';

export default function SearchScreen() {
  const { colors } = useTheme();
  const [query, setQuery] = useState('');
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(false);
  const [searched, setSearched] = useState(false);
  const [bookmarkedIds, setBookmarkedIds] = useState(new Set());

  const handleSearch = useCallback(async () => {
    const trimmed = query.trim();
    if (!trimmed) return;
    Keyboard.dismiss();
    setLoading(true);
    setSearched(true);
    const result = await searchArticles(trimmed);
    setArticles(result.articles);
    setLoading(false);
  }, [query]);

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

  const clearSearch = () => {
    setQuery('');
    setArticles([]);
    setSearched(false);
  };

  const styles = makeStyles(colors);

  return (
    <View style={styles.container}>
      <View style={styles.searchRow}>
        <View style={styles.inputWrap}>
          <Ionicons name="search" size={18} color={colors.textTertiary} style={styles.searchIcon} />
          <TextInput
            style={styles.input}
            placeholder="Search news…"
            placeholderTextColor={colors.textTertiary}
            value={query}
            onChangeText={setQuery}
            onSubmitEditing={handleSearch}
            returnKeyType="search"
            autoCorrect={false}
          />
          {query.length > 0 && (
            <TouchableOpacity onPress={clearSearch} hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
              <Ionicons name="close-circle" size={18} color={colors.textTertiary} />
            </TouchableOpacity>
          )}
        </View>
        <TouchableOpacity style={styles.searchBtn} onPress={handleSearch}>
          <Text style={styles.searchBtnText}>Search</Text>
        </TouchableOpacity>
      </View>

      {loading ? (
        <ActivityIndicator style={styles.loader} color={colors.accent} size="large" />
      ) : searched && articles.length === 0 ? (
        <View style={styles.centered}>
          <Ionicons name="newspaper-outline" size={48} color={colors.textTertiary} />
          <Text style={styles.emptyText}>No results for "{query}"</Text>
        </View>
      ) : !searched ? (
        <View style={styles.centered}>
          <Ionicons name="search-outline" size={48} color={colors.textTertiary} />
          <Text style={styles.hintText}>Search for any topic or keyword</Text>
        </View>
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
          keyboardShouldPersistTaps="handled"
        />
      )}
    </View>
  );
}

function makeStyles(colors) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    searchRow: {
      flexDirection: 'row',
      alignItems: 'center',
      paddingHorizontal: 16,
      paddingVertical: 12,
      gap: 10,
    },
    inputWrap: {
      flex: 1,
      flexDirection: 'row',
      alignItems: 'center',
      backgroundColor: colors.searchBar,
      borderRadius: 10,
      paddingHorizontal: 10,
      height: 40,
    },
    searchIcon: { marginRight: 6 },
    input: {
      flex: 1,
      fontSize: 15,
      color: colors.text,
      height: 40,
    },
    searchBtn: {
      backgroundColor: colors.accent,
      borderRadius: 10,
      paddingHorizontal: 14,
      height: 40,
      justifyContent: 'center',
    },
    searchBtnText: {
      color: '#FFFFFF',
      fontWeight: '600',
      fontSize: 14,
    },
    loader: { marginTop: 60 },
    list: { paddingTop: 8, paddingBottom: 24 },
    centered: {
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
      paddingBottom: 80,
    },
    emptyText: {
      marginTop: 12,
      color: colors.textSecondary,
      fontSize: 15,
      textAlign: 'center',
    },
    hintText: {
      marginTop: 12,
      color: colors.textTertiary,
      fontSize: 15,
      textAlign: 'center',
    },
  });
}
