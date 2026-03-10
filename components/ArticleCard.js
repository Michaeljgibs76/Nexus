import { router } from 'expo-router';
import { TouchableOpacity, Text, Image, View, StyleSheet } from 'react-native';
import { useTheme } from '../context/ThemeContext';

function ArticleCard({ article, onLongPress }) {
  const { colors } = useTheme();

  return (
    <TouchableOpacity
      style={[styles.card, { backgroundColor: colors.card, shadowColor: colors.shadow }]}
      onPress={() => router.push(`/article/${article.id}`)}
      onLongPress={onLongPress}
      activeOpacity={0.7}
    >
      {article.imageUrl && (
        <Image source={{ uri: article.imageUrl }} style={styles.image} />
      )}
      <View style={styles.content}>
        <Text style={[styles.source, { color: colors.accent }]}>{article.source}</Text>
        <Text style={[styles.title, { color: colors.text }]} numberOfLines={3}>
          {article.title}
        </Text>
        <Text style={[styles.timestamp, { color: colors.textTertiary }]}>
          {article.timeAgo}
        </Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    borderRadius: 12,
    marginHorizontal: 16,
    marginVertical: 8,
    overflow: 'hidden',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  image: { width: '100%', height: 200 },
  content: { padding: 12 },
  source: {
    fontSize: 12, fontWeight: '600',
    textTransform: 'uppercase', marginBottom: 4,
  },
  title: {
    fontSize: 17, fontWeight: '700',
    lineHeight: 22, marginBottom: 6,
  },
  timestamp: { fontSize: 12 },
});

export default ArticleCard;
