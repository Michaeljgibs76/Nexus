import { useState, useCallback } from 'react';
import {
  View,
  FlatList,
  Text,
  TouchableOpacity,
  Alert,
  StyleSheet,
} from 'react-native';
import { useFocusEffect } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import ArticleCard from '../../components/ArticleCard';
import { getBookmarks, removeBookmark as removeFromStorage } from '../../services/bookmarks';
import { useTheme } from '../../context/ThemeContext';

export default function Bookmarks() {
  const { colors } = useTheme();
  const [bookmarks, setBookmarks] = useState([]);

  useFocusEffect(
    useCallback(() => {
      loadBookmarks();
    }, [])
  );

  const loadBookmarks = async () => {
    const stored = await getBookmarks();
    setBookmarks(stored);
  };

  const clearAll = () => {
    Alert.alert(
      'Clear All Bookmarks',
      'Are you sure? This cannot be undone.',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Clear All',
          style: 'destructive',
          onPress: async () => {
            const AsyncStorage = require('@react-native-async-storage/async-storage').default;
            await AsyncStorage.removeItem('@nexusnews_bookmarks');
            setBookmarks([]);
          },
        },
      ]
    );
  };

  const handleRemove = async (articleId) => {
    await removeFromStorage(articleId);
    setBookmarks((prev) => prev.filter((a) => a.id !== articleId));
  };

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <View style={styles.headerRow}>
        <Text style={[styles.header, { color: colors.text }]}>Saved</Text>
        {bookmarks.length > 0 && (
          <TouchableOpacity onPress={clearAll} style={styles.clearBtn}>
            <Text style={[styles.clearText, { color: colors.danger }]}>Clear All</Text>
          </TouchableOpacity>
        )}
      </View>

      <FlatList
        data={bookmarks}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <ArticleCard
            article={item}
            onLongPress={() => {
              Alert.alert('Remove Bookmark', 'Remove this article?', [
                { text: 'Cancel', style: 'cancel' },
                {
                  text: 'Remove',
                  style: 'destructive',
                  onPress: () => handleRemove(item.id),
                },
              ]);
            }}
          />
        )}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Ionicons name="bookmark-outline" size={48} color={colors.textTertiary} />
            <Text style={[styles.emptyTitle, { color: colors.text }]}>No saved articles</Text>
            <Text style={[styles.emptySubtitle, { color: colors.textTertiary }]}>
              Bookmark articles to read them later
            </Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  headerRow: {
    flexDirection: 'row', justifyContent: 'space-between',
    alignItems: 'flex-end', paddingHorizontal: 16,
    paddingTop: 60, paddingBottom: 16,
  },
  header: { fontSize: 34, fontWeight: '800' },
  clearBtn: { paddingBottom: 4 },
  clearText: { fontSize: 16, fontWeight: '600' },
  emptyContainer: { alignItems: 'center', paddingTop: 120, gap: 8 },
  emptyTitle: { fontSize: 18, fontWeight: '700' },
  emptySubtitle: { fontSize: 14 },
});
