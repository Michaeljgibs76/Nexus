import { View, Text, TouchableOpacity, Switch, ScrollView, StyleSheet } from 'react-native';
import { useState } from 'react';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';

const CATEGORIES = ['Business', 'Technology', 'Science', 'Health', 'Sports', 'Entertainment'];

export default function Profile() {
  const { colors, isDark, toggleTheme } = useTheme();
  const [notifications, setNotifications] = useState(true);
  const [selectedCategories, setSelectedCategories] = useState(['Technology', 'Science']);

  const toggleCategory = (cat) => {
    setSelectedCategories((prev) =>
      prev.includes(cat) ? prev.filter((c) => c !== cat) : [...prev, cat]
    );
  };

  return (
    <ScrollView style={[styles.container, { backgroundColor: colors.background }]}>
      <Text style={[styles.header, { color: colors.text }]}>Profile</Text>

      <View style={[styles.userCard, { backgroundColor: colors.surface }]}>
        <View style={[styles.avatar, { backgroundColor: colors.accent }]}>
          <Ionicons name="person" size={32} color="#FFFFFF" />
        </View>
        <View>
          <Text style={[styles.userName, { color: colors.text }]}>Reader</Text>
          <Text style={[styles.userSub, { color: colors.textTertiary }]}>Free Plan</Text>
        </View>
      </View>

      <Text style={[styles.sectionTitle, { color: colors.text }]}>Preferences</Text>
      <View style={[styles.section, { backgroundColor: colors.surface }]}>
        <SettingRow
          icon="moon-outline"
          label="Dark Mode"
          colors={colors}
          right={
            <Switch
              value={isDark}
              onValueChange={toggleTheme}
              trackColor={{ true: colors.accent }}
            />
          }
        />
        <View style={[styles.separator, { backgroundColor: colors.separator }]} />
        <SettingRow
          icon="notifications-outline"
          label="Push Notifications"
          colors={colors}
          right={
            <Switch
              value={notifications}
              onValueChange={setNotifications}
              trackColor={{ true: colors.accent }}
            />
          }
        />
      </View>

      <Text style={[styles.sectionTitle, { color: colors.text }]}>Your Interests</Text>
      <View style={styles.categoriesGrid}>
        {CATEGORIES.map((cat) => {
          const selected = selectedCategories.includes(cat);
          return (
            <TouchableOpacity
              key={cat}
              style={[
                styles.categoryChip,
                { backgroundColor: colors.chipBg, borderColor: colors.chipBorder },
                selected && { backgroundColor: colors.accent, borderColor: colors.accent },
              ]}
              onPress={() => toggleCategory(cat)}
            >
              <Text
                style={[
                  styles.categoryText,
                  { color: colors.textTertiary },
                  selected && { color: '#FFFFFF' },
                ]}
              >
                {cat}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      <Text style={[styles.sectionTitle, { color: colors.text }]}>About</Text>
      <View style={[styles.section, { backgroundColor: colors.surface }]}>
        <SettingRow icon="document-text-outline" label="Terms of Service" colors={colors} showArrow />
        <View style={[styles.separator, { backgroundColor: colors.separator }]} />
        <SettingRow icon="shield-outline" label="Privacy Policy" colors={colors} showArrow />
        <View style={[styles.separator, { backgroundColor: colors.separator }]} />
        <SettingRow icon="information-circle-outline" label="App Version" colors={colors} right={
          <Text style={{ fontSize: 16, color: colors.textTertiary }}>1.0.0</Text>
        } />
      </View>

      <View style={styles.bottomSpacer} />
    </ScrollView>
  );
}

function SettingRow({ icon, label, right, showArrow, colors }) {
  return (
    <TouchableOpacity style={styles.settingRow} disabled={!showArrow}>
      <Ionicons name={icon} size={22} color={colors.accent} />
      <Text style={[styles.settingLabel, { color: colors.text }]}>{label}</Text>
      <View style={styles.settingRight}>
        {right}
        {showArrow && <Ionicons name="chevron-forward" size={18} color={colors.textTertiary} />}
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  header: {
    fontSize: 34, fontWeight: '800',
    paddingHorizontal: 16, paddingTop: 60, paddingBottom: 16,
  },
  userCard: {
    flexDirection: 'row', alignItems: 'center', gap: 14,
    marginHorizontal: 16, padding: 16, borderRadius: 12,
    shadowColor: '#000', shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.06, shadowRadius: 2,
  },
  avatar: {
    width: 56, height: 56, borderRadius: 28,
    justifyContent: 'center', alignItems: 'center',
  },
  userName: { fontSize: 18, fontWeight: '700' },
  userSub: { fontSize: 14, marginTop: 2 },
  sectionTitle: {
    fontSize: 18, fontWeight: '700',
    paddingHorizontal: 16, marginTop: 28, marginBottom: 10,
  },
  section: {
    marginHorizontal: 16, borderRadius: 12, overflow: 'hidden',
  },
  settingRow: {
    flexDirection: 'row', alignItems: 'center',
    paddingHorizontal: 16, paddingVertical: 14, gap: 12,
  },
  settingLabel: { flex: 1, fontSize: 16 },
  settingRight: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  separator: { height: 1, marginLeft: 50 },
  categoriesGrid: {
    flexDirection: 'row', flexWrap: 'wrap', gap: 8,
    paddingHorizontal: 16,
  },
  categoryChip: {
    paddingHorizontal: 16, paddingVertical: 10,
    borderRadius: 20, borderWidth: 1.5,
  },
  categoryText: { fontSize: 14, fontWeight: '600' },
  bottomSpacer: { height: 60 },
});
