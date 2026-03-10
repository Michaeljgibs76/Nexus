import React from 'react';
import {
  View,
  Text,
  Switch,
  TouchableOpacity,
  ScrollView,
  StyleSheet,
  Linking,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useTheme } from '../../context/ThemeContext';

function SettingRow({ icon, label, value, onPress, right }) {
  const { colors } = useTheme();
  return (
    <TouchableOpacity
      style={[styles.row, { borderBottomColor: colors.separator }]}
      onPress={onPress}
      disabled={!onPress}
      activeOpacity={onPress ? 0.7 : 1}
    >
      <View style={[styles.iconWrap, { backgroundColor: colors.searchBar }]}>
        <Ionicons name={icon} size={20} color={colors.accent} />
      </View>
      <Text style={[styles.rowLabel, { color: colors.text }]}>{label}</Text>
      <View style={styles.rowRight}>
        {right || (
          value !== undefined ? null : (
            <Ionicons name="chevron-forward" size={16} color={colors.textTertiary} />
          )
        )}
        {value !== undefined && (
          <Ionicons name="chevron-forward" size={16} color={colors.textTertiary} />
        )}
      </View>
    </TouchableOpacity>
  );
}

export default function ProfileScreen() {
  const { colors, isDark, toggleTheme } = useTheme();

  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.background }}>
      {/* App info */}
      <View style={[styles.header, { backgroundColor: colors.surface }]}>
        <View style={[styles.appIcon, { backgroundColor: colors.accent }]}>
          <Ionicons name="newspaper" size={36} color="#fff" />
        </View>
        <Text style={[styles.appName, { color: colors.text }]}>Nexus News</Text>
        <Text style={[styles.appVersion, { color: colors.textSecondary }]}>Version 1.0.0</Text>
      </View>

      {/* Appearance */}
      <Text style={[styles.sectionTitle, { color: colors.textSecondary }]}>APPEARANCE</Text>
      <View style={[styles.section, { backgroundColor: colors.surface, borderColor: colors.separator }]}>
        <View style={[styles.row, { borderBottomColor: colors.separator }]}>
          <View style={[styles.iconWrap, { backgroundColor: colors.searchBar }]}>
            <Ionicons name={isDark ? 'moon' : 'sunny'} size={20} color={colors.accent} />
          </View>
          <Text style={[styles.rowLabel, { color: colors.text }]}>Dark Mode</Text>
          <Switch
            value={isDark}
            onValueChange={toggleTheme}
            trackColor={{ true: colors.accent, false: colors.separator }}
            thumbColor="#fff"
          />
        </View>
      </View>

      {/* About */}
      <Text style={[styles.sectionTitle, { color: colors.textSecondary }]}>ABOUT</Text>
      <View style={[styles.section, { backgroundColor: colors.surface, borderColor: colors.separator }]}>
        <SettingRow
          icon="globe-outline"
          label="Powered by NewsAPI"
          onPress={() => Linking.openURL('https://newsapi.org')}
        />
        <SettingRow
          icon="code-slash-outline"
          label="Built with Expo & React Native"
        />
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  header: {
    alignItems: 'center',
    paddingVertical: 32,
    marginBottom: 8,
  },
  appIcon: {
    width: 80,
    height: 80,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 12,
  },
  appName: {
    fontSize: 22,
    fontWeight: '800',
  },
  appVersion: {
    fontSize: 13,
    marginTop: 4,
  },
  sectionTitle: {
    fontSize: 12,
    fontWeight: '600',
    letterSpacing: 0.5,
    marginLeft: 16,
    marginTop: 24,
    marginBottom: 6,
  },
  section: {
    borderTopWidth: StyleSheet.hairlineWidth,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  iconWrap: {
    width: 34,
    height: 34,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  rowLabel: {
    flex: 1,
    fontSize: 15,
  },
  rowRight: {
    flexDirection: 'row',
    alignItems: 'center',
  },
});
