import create from 'zustand';
import axios from 'axios';
import { persist } from 'zustand/middleware';

const useAuthStore = create(
  persist(
    (set) => ({
      user: null,
      isAuthenticated: false,
      setUser: (user) => set({ user, isAuthenticated: !!user }),
      logout: () => set({ user: null, isAuthenticated: false }),
    }),
    {
      name: 'auth-storage',
    }
  )
);

export function useAuth() {
  const { user, isAuthenticated, setUser, logout } = useAuthStore();

  const login = async (email, password) => {
    try {
      const response = await axios.post('/api/v1/users/login', {
        email,
        password,
      });
      setUser(response.data.data.user);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  };

  const register = async (userData) => {
    try {
      const response = await axios.post('/api/v1/users/register', userData);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  };

  const updateProfile = async (data) => {
    try {
      const response = await axios.patch('/api/v1/users/update-profile', data);
      setUser(response.data.data);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  };

  const handleLogout = async () => {
    try {
      await axios.post('/api/v1/users/logout');
      logout();
    } catch (error) {
      console.error('Logout error:', error);
      logout(); // Still clear local state even if API call fails
    }
  };

  return {
    user,
    isAuthenticated,
    login,
    logout: handleLogout,
    register,
    updateProfile,
  };
} 