import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  Image,
  ScrollView,
  TouchableOpacity,
  Share,
  Linking,
  StyleSheet,
} from 'react-native';
import { useLocalSearchParams, useNavigation } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';
import { addBookmark, removeBookmark, isBookmarked } from '../../services/bookmarks';

export default function ArticleScreen() {
  const { colors } = useTheme();
  const { data } = useLocalSearchParams();
  const navigation = useNavigation();
  const [bookmarked, setBookmarked] = useState(false);

  const article = data ? JSON.parse(data) : null;

  useEffect(() => {
    if (!article) return;
    isBookmarked(article.id).then(setBookmarked);
  }, [article?.id]);

  useEffect(() => {
    if (!article) return;
    navigation.setOptions({
      headerRight: () => (
        <View style={{ flexDirection: 'row', gap: 8, marginRight: 8 }}>
          <TouchableOpacity onPress={handleShare} hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
            <Ionicons name="share-outline" size={24} color={colors.accent} />
          </TouchableOpacity>
          <TouchableOpacity onPress={handleBookmark} hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
            <Ionicons
              name={bookmarked ? 'bookmark' : 'bookmark-outline'}
              size={24}
              color={colors.accent}
            />
          </TouchableOpacity>
        </View>
      ),
    });
  }, [article, bookmarked, colors]);

  const handleBookmark = async () => {
    if (bookmarked) {
      await removeBookmark(article.id);
      setBookmarked(false);
    } else {
      await addBookmark(article);
      setBookmarked(true);
    }
  };

  const handleShare = () => {
    Share.share({ title: article.title, url: article.url, message: article.url });
  };

  const handleOpenSource = () => {
    if (article?.url) Linking.openURL(article.url);
  };

  if (!article) {
    return (
      <View style={[styles.centered, { backgroundColor: colors.background }]}>
        <Text style={{ color: colors.textSecondary }}>Article not found.</Text>
      </View>
    );
  }

  const styles = makeStyles(colors);

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {article.imageUrl && (
        <Image source={{ uri: article.imageUrl }} style={styles.image} resizeMode="cover" />
      )}

      <View style={styles.body}>
        <Text style={styles.source}>{article.source}</Text>
        <Text style={styles.title}>{article.title}</Text>

        <View style={styles.metaRow}>
          {article.author ? (
            <Text style={styles.author} numberOfLines={1}>{article.author}</Text>
          ) : null}
          <Text style={styles.date}>{article.publishedAt}</Text>
        </View>

        {article.description ? (
          <Text style={styles.description}>{article.description}</Text>
        ) : null}

        {article.body ? (
          <Text style={styles.bodyText}>{article.body}</Text>
        ) : null}

        <TouchableOpacity style={styles.readMoreBtn} onPress={handleOpenSource}>
          <Text style={styles.readMoreText}>Read Full Article</Text>
          <Ionicons name="open-outline" size={16} color={colors.accent} style={{ marginLeft: 6 }} />
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

function makeStyles(colors) {
  return StyleSheet.create({
    container: { flex: 1, backgroundColor: colors.background },
    content: { paddingBottom: 40 },
    image: { width: '100%', height: 240, backgroundColor: colors.separator },
    body: { padding: 20 },
    source: {
      fontSize: 12,
      fontWeight: '700',
      textTransform: 'uppercase',
      color: colors.accent,
      marginBottom: 10,
      letterSpacing: 0.5,
    },
    title: {
      fontSize: 22,
      fontWeight: '800',
      color: colors.text,
      lineHeight: 30,
      marginBottom: 12,
    },
    metaRow: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      marginBottom: 16,
      flexWrap: 'wrap',
      gap: 4,
    },
    author: {
      fontSize: 13,
      color: colors.textSecondary,
      flex: 1,
    },
    date: {
      fontSize: 13,
      color: colors.textTertiary,
    },
    description: {
      fontSize: 16,
      color: colors.text,
      lineHeight: 24,
      marginBottom: 16,
      fontWeight: '500',
    },
    bodyText: {
      fontSize: 15,
      color: colors.textSecondary,
      lineHeight: 24,
      marginBottom: 24,
    },
    readMoreBtn: {
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent: 'center',
      borderWidth: 1.5,
      borderColor: colors.accent,
      borderRadius: 10,
      paddingVertical: 12,
      marginTop: 8,
    },
    readMoreText: {
      color: colors.accent,
      fontWeight: '700',
      fontSize: 15,
    },
    centered: {
      flex: 1,
      alignItems: 'center',
      justifyContent: 'center',
    },
  });
}
