import React, { useState, useCallback } from 'react';
import {
  View,
  FlatList,
  Text,
  Alert,
  StyleSheet,
} from 'react-native';
import { useFocusEffect } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';
import { getBookmarks, removeBookmark } from '../../services/bookmarks';
import ArticleCard from '../../components/ArticleCard';

export default function BookmarksScreen() {
  const { colors } = useTheme();
  const [bookmarks, setBookmarks] = useState([]);

  useFocusEffect(
    useCallback(() => {
      getBookmarks().then(setBookmarks);
    }, [])
  );

  const handleLongPress = (article) => {
    Alert.alert('Remove Bookmark', `Remove "${article.title}" from bookmarks?`, [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Remove',
        style: 'destructive',
        onPress: async () => {
          await removeBookmark(article.id);
          setBookmarks((prev) => prev.filter((a) => a.id !== article.id));
        },
      },
    ]);
  };

  const styles = makeStyles(colors);

  return (
    <View style={styles.container}>
      {bookmarks.length === 0 ? (
        <View style={styles.centered}>
          <Ionicons name="bookmark-outline" size={56} color={colors.textTertiary} />
          <Text style={styles.emptyTitle}>No Bookmarks Yet</Text>
          <Text style={styles.emptySubtitle}>Long-press any article to save it here.</Text>
        </View>
      ) : (
        <FlatList
          data={bookmarks}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => (
            <ArticleCard
              article={item}
              onLongPress={() => handleLongPress(item)}
            />
          )}
          contentContainerStyle={styles.list}
        />
      )}
    </View>
  );
}

function makeStyles(colors) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    list: { paddingVertical: 8 },
    centered: {
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
      paddingBottom: 80,
    },
    emptyTitle: {
      marginTop: 16,
      fontSize: 18,
      fontWeight: '700',
      color: colors.text,
    },
    emptySubtitle: {
      marginTop: 8,
      fontSize: 14,
      color: colors.textSecondary,
      textAlign: 'center',
      paddingHorizontal: 40,
    },
  });
}
