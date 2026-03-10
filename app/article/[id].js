import { useLocalSearchParams, Stack, router } from 'expo-router';
import { useState, useEffect } from 'react';
import {
  View,
  Text,
  Image,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Share,
  Linking,
  StyleSheet,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';
import { addBookmark, removeBookmark, isBookmarked as checkBookmark } from '../../services/bookmarks';

const API_URL = 'https://newsapi.org/v2';
const API_KEY = 'your_api_key_here';

export default function Article() {
  const { id } = useLocalSearchParams();
  const { colors } = useTheme();
  const [article, setArticle] = useState(null);
  const [loading, setLoading] = useState(true);
  const [bookmarked, setBookmarked] = useState(false);

  useEffect(() => {
    fetchArticle();
    checkIfBookmarked();
  }, [id]);

  const fetchArticle = async () => {
    try {
      // NewsAPI doesn't support fetch-by-id, so use the URL as lookup
      // In production, you'd cache articles or use your own backend
      const res = await fetch(
        `${API_URL}/everything?qInTitle=${encodeURIComponent(id)}&pageSize=1&apiKey=${API_KEY}`
      );
      const data = await res.json();
      if (data.articles?.length > 0) {
        const raw = data.articles[0];
        setArticle({
          id: raw.url,
          title: raw.title,
          author: raw.author,
          source: raw.source?.name,
          publishedAt: new Date(raw.publishedAt).toLocaleDateString('en-US', {
            month: 'long', day: 'numeric', year: 'numeric',
          }),
          imageUrl: raw.urlToImage,
          body: raw.content || raw.description || '',
          url: raw.url,
        });
      }
    } catch (err) {
      console.error('Failed to fetch article:', err);
    } finally {
      setLoading(false);
    }
  };

  const checkIfBookmarked = async () => {
    const result = await checkBookmark(id);
    setBookmarked(result);
  };

  const onShare = async () => {
    if (!article) return;
    try {
      await Share.share({
        title: article.title,
        message: `${article.title}\n\n${article.url}`,
      });
    } catch (err) {
      console.error('Share failed:', err);
    }
  };

  const onBookmark = async () => {
    if (bookmarked) {
      await removeBookmark(article.id);
    } else {
      await addBookmark(article);
    }
    setBookmarked((prev) => !prev);
  };

  const onOpenSource = () => {
    if (article?.url) {
      Linking.openURL(article.url);
    }
  };

  if (loading) {
    return (
      <View style={[styles.centered, { backgroundColor: colors.background }]}>
        <ActivityIndicator size="large" color={colors.accent} />
      </View>
    );
  }

  if (!article) {
    return (
      <View style={[styles.centered, { backgroundColor: colors.background }]}>
        <Text style={[styles.errorText, { color: colors.textTertiary }]}>Article not found</Text>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={{ fontSize: 16, color: colors.accent }}>Go back</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <>
      <Stack.Screen
        options={{
          headerShown: true,
          headerTitle: '',
          headerTransparent: true,
          headerRight: () => (
            <View style={styles.headerActions}>
              <TouchableOpacity onPress={onBookmark} style={styles.headerBtn}>
                <Ionicons
                  name={bookmarked ? 'bookmark' : 'bookmark-outline'}
                  size={22}
                  color={colors.accent}
                />
              </TouchableOpacity>
              <TouchableOpacity onPress={onShare} style={styles.headerBtn}>
                <Ionicons name="share-outline" size={22} color={colors.accent} />
              </TouchableOpacity>
            </View>
          ),
        }}
      />
      <ScrollView style={[styles.container, { backgroundColor: colors.background }]} bounces={true}>
        {article.imageUrl && (
          <Image source={{ uri: article.imageUrl }} style={styles.heroImage} />
        )}

        <View style={styles.content}>
          <View style={styles.meta}>
            <Text style={[styles.source, { color: colors.accent }]}>{article.source}</Text>
            <Text style={{ fontSize: 13, color: colors.textTertiary, marginHorizontal: 6 }}>·</Text>
            <Text style={{ fontSize: 13, color: colors.textTertiary }}>{article.publishedAt}</Text>
          </View>

          <Text style={[styles.title, { color: colors.text }]}>{article.title}</Text>

          {article.author && (
            <Text style={[styles.author, { color: colors.textSecondary }]}>
              By {article.author}
            </Text>
          )}

          <View style={[styles.divider, { backgroundColor: colors.separator }]} />

          <Text style={[styles.body, { color: colors.text }]}>{article.body}</Text>

          {article.body?.endsWith('…') && (
            <Text style={{ fontSize: 14, color: colors.textTertiary, marginBottom: 16 }}>
              Article content is truncated. Tap below to read the full article.
            </Text>
          )}

          <TouchableOpacity
            style={[styles.sourceBtn, { backgroundColor: colors.surface }]}
            onPress={onOpenSource}
          >
            <Ionicons name="open-outline" size={16} color={colors.accent} />
            <Text style={{ fontSize: 14, fontWeight: '600', color: colors.accent }}>
              Read full article at source
            </Text>
          </TouchableOpacity>
        </View>

        <View style={styles.bottomSpacer} />
      </ScrollView>
    </>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  centered: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  errorText: { fontSize: 16, marginBottom: 12 },
  headerActions: { flexDirection: 'row', gap: 8 },
  headerBtn: { padding: 6 },
  heroImage: { width: '100%', height: 300 },
  content: { padding: 20 },
  meta: { flexDirection: 'row', alignItems: 'center', marginBottom: 12 },
  source: { fontSize: 13, fontWeight: '600', textTransform: 'uppercase' },
  title: { fontSize: 28, fontWeight: '800', lineHeight: 34, marginBottom: 8 },
  author: { fontSize: 14, marginBottom: 16 },
  divider: { height: 1, marginBottom: 20 },
  body: { fontSize: 17, lineHeight: 28, marginBottom: 24 },
  sourceBtn: {
    flexDirection: 'row', alignItems: 'center', alignSelf: 'flex-start',
    paddingVertical: 10, paddingHorizontal: 16, borderRadius: 8, gap: 6,
  },
  bottomSpacer: { height: 60 },
});
