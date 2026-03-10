import { createContext, useContext, useState, useEffect, useMemo } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const THEME_KEY = '@nexusnews_theme';

const lightColors = {
  background: '#F2F2F7',
  surface: '#FFFFFF',
  card: '#FFFFFF',
  text: '#1C1C1E',
  textSecondary: '#636366',
  textTertiary: '#8E8E93',
  accent: '#007AFF',
  separator: '#E5E5EA',
  searchBar: '#E5E5EA',
  danger: '#FF3B30',
  chipBorder: '#E5E5EA',
  chipBg: '#FFFFFF',
  shadow: '#000',
  statusBar: 'dark-content',
};

const darkColors = {
  background: '#000000',
  surface: '#1C1C1E',
  card: '#1C1C1E',
  text: '#FFFFFF',
  textSecondary: '#ABABAF',
  textTertiary: '#636366',
  accent: '#0A84FF',
  separator: '#38383A',
  searchBar: '#1C1C1E',
  danger: '#FF453A',
  chipBorder: '#38383A',
  chipBg: '#1C1C1E',
  shadow: '#000',
  statusBar: 'light-content',
};

const ThemeContext = createContext();

export function ThemeProvider({ children }) {
  const [isDark, setIsDark] = useState(false);

  useEffect(() => {
    AsyncStorage.getItem(THEME_KEY).then((stored) => {
      if (stored !== null) setIsDark(stored === 'dark');
    });
  }, []);

  const toggleTheme = async () => {
    const next = !isDark;
    setIsDark(next);
    await AsyncStorage.setItem(THEME_KEY, next ? 'dark' : 'light');
  };

  const value = useMemo(
    () => ({
      isDark,
      colors: isDark ? darkColors : lightColors,
      toggleTheme,
    }),
    [isDark]
  );

  return (
    <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
  );
}

export const useTheme = () => useContext(ThemeContext);
